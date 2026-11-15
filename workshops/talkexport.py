#!/usr/bin/env python3
"""Export a talkdir beamer talk (e.g. evaluation.slides.tex) to human-friendly formats.

Reads the *generated* .tex (not the .txt), so venue settings (daidd.set etc.)
are already applied. Writes a self-contained folder <stem>_export/ with:

  <stem>.pptx      editable PowerPoint (pandoc)
  <stem>.pix.pptx  pixel-perfect PowerPoint, one image per PDF page (if --pdf)
  <stem>.qmd       Quarto source (revealjs by default)
  <stem>.Rmd       R Markdown source (ioslides by default)
  <stem>.typ       Typst source (no packages needed)
  <stem>.md        the pandoc Markdown intermediate
  images/          every figure, PDFs converted to PNG

With --render, also renders the .qmd (to a single-file .html) and the .typ
(to .pdf) to check that they work. --zip makes <stem>_export.zip.

Needs pandoc and pdftoppm; --render also uses quarto (which bundles typst).
"""

import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile
import zipfile
from xml.etree import ElementTree as ET
from xml.sax.saxutils import escape

warnings = set()

def warn(msg):
	if msg not in warnings:
		warnings.add(msg)
		print("talkexport: " + msg, file=sys.stderr)

######################################################################

## Brace-matching helpers

def group(s, i, open_="{", close="}"):
	"""s[i] is open_; return (contents, index after the matching close)."""
	depth = 0
	for j in range(i, len(s)):
		if s[j] == "\\":
			continue
		if s[j] == open_ and (j == 0 or s[j-1] != "\\"):
			depth += 1
		elif s[j] == close and s[j-1] != "\\":
			depth -= 1
			if depth == 0:
				return s[i+1:j], j+1
	return s[i+1:], len(s)

def skip_ws(s, i):
	while i < len(s) and s[i] in " \t\n":
		i += 1
	return i

def command_args(s, i, nopt=1, nreq=1):
	"""Parse up to nopt [..] and then nreq {..} args starting at i."""
	opts, reqs = [], []
	j = skip_ws(s, i)
	while len(opts) < nopt and j < len(s) and s[j] == "[":
		o, j = group(s, j, "[", "]")
		opts.append(o)
		j = skip_ws(s, j)
	while len(reqs) < nreq:
		j = skip_ws(s, j)
		if j < len(s) and s[j] == "{":
			r, j = group(s, j)
			reqs.append(r)
		else:
			break
	return opts, reqs, j

######################################################################

## Inline LaTeX -> Markdown

## Commands whose argument we keep, wrapped in markdown
WRAP = {
	"emph": ("*", "*"), "textit": ("*", "*"), "textsl": ("*", "*"),
	"textbf": ("**", "**"), "sout": ("~~", "~~"),
	"texttt": ("`", "`"), "underline": ("", ""), "mbox": ("", ""),
	"text": ("", ""), "uncover": ("", ""), "only": ("", ""),
	"chinese": ("", ""),
}
## Commands we drop (with their arguments, if any)
DROP0 = {"hfill", "vfill", "small", "footnotesize", "scriptsize", "tiny",
	"large", "Large", "normalsize", "centering", "sl", "em", "bf", "it",
	"medskip", "bigskip", "smallskip", "noindent", "pause", "par", "relax"}
DROP1 = {"hspace", "vspace", "label", "framesubtitle"}
SYMBOLS = {"ldots": "…", "dots": "…", "%": "%", "&": "&", "_": "_",
	"#": "#", "$": "\\$", "{": "{", "}": "}", "times": "×", "to": "→",
	"implies": "⇒", "pm": "±", "LaTeX": "LaTeX", "TeX": "TeX", " ": " ",
	",": " ", "\\": " "}
## User macros, read by load_macros() from the files the talk \usepackage's
## and \input's (e.g., talkdir/commands.sty) and from the document itself.
## name -> (nargs, default for an optional first arg or None, body)
USERMACROS = {}

## Read files the way latex would find them locally; system packages
## (which aren't found locally) are skipped
def _read_local(path):
	try:
		with open(path) as f:
			return f.read()
	except OSError:
		return None

def _strip_comments(s):
	return re.sub(r"(?<!\\)%.*", "", s)

DEFPAT = re.compile(r"\\(?:re|provide)?newcommand\*?\s*(?:\{\s*\\([a-zA-Z]+)\s*\}|\\([a-zA-Z]+))"
	r"|\\(usepackage|RequirePackage|input|include)\s*(?:\[[^\]]*\])?\s*\{([^}]*)\}")

def _scan_defs(tex, texdir, seen):
	tex = _strip_comments(tex)
	for m in DEFPAT.finditer(tex):
		if m.group(3):
			names = [n.strip() for n in m.group(4).split(",")]
			ext = ".sty" if "Package" in m.group(3) or m.group(3) == "usepackage" else ".tex"
			for n in names:
				f = n if os.path.splitext(n)[1] else n + ext
				f = os.path.normpath(os.path.join(texdir, f))
				if f in seen:
					continue
				seen.add(f)
				t = _read_local(f)
				if t is not None:
					_scan_defs(t, texdir, seen) ## latex paths are relative to the main file
			continue
		name = m.group(1) or m.group(2)
		opts, reqs, j = command_args(tex, m.end(), 2, 0)
		nargs = int(opts[0]) if opts and opts[0].strip().isdigit() else 0
		default = opts[1] if len(opts) > 1 else None
		j = skip_ws(tex, j)
		if j < len(tex) and tex[j] == "{":
			body, _ = group(tex, j)
			if "providecommand" in m.group(0) and name in USERMACROS:
				continue
			USERMACROS[name] = (nargs, default, body)

def load_macros(tex, texdir):
	"""Collect user macro definitions, in the order latex would see them."""
	USERMACROS.clear()
	_scan_defs(tex, texdir or ".", set())

def _macro_arg(s, i):
	"""One macro argument at s[i]: a braced group or a single token."""
	i = skip_ws(s, i)
	if i >= len(s):
		return "", i
	if s[i] == "{":
		return group(s, i)
	m = re.match(r"\\[a-zA-Z]+|\\.|.", s[i:], re.S)
	return m.group(0), i + m.end()

def _macro_end(s, name, i):
	"""Index after the arguments of user macro name, used at s[i]."""
	nargs, default, _ = USERMACROS[name]
	if default is not None:
		k = skip_ws(s, i)
		if k < len(s) and s[k] == "[":
			_, i = group(s, k, "[", "]")
	for _ in range(nargs - (default is not None)):
		_, i = _macro_arg(s, i)
	return i

MACROPAT = re.compile(r"\\([a-zA-Z]+)")

def expand(s, ok=lambda name: True, depth=0):
	"""Expand user macros (for which ok(name)) in s, recursively."""
	if depth > 20:
		warn("macros nested too deep (recursive definition?) in: " + s[:40])
		return s
	out = []
	i = 0
	while True:
		m = MACROPAT.search(s, i)
		if not m:
			out.append(s[i:]); break
		name = m.group(1)
		out.append(s[i:m.start()])
		i = m.end()
		if name not in USERMACROS or not ok(name):
			out.append(m.group(0)); continue
		nargs, default, body = USERMACROS[name]
		args = []
		if nargs:
			if default is not None:
				j = skip_ws(s, i)
				if j < len(s) and s[j] == "[":
					a, i = group(s, j, "[", "]")
				else:
					a = default
				args.append(a)
			while len(args) < nargs:
				a, i = _macro_arg(s, i)
				args.append(a)
		for k in range(nargs, 0, -1):
			body = body.replace("#%d" % k, args[k-1])
		## A macro ending in a letter mustn't run into following letters
		out.append(expand(body, ok, depth+1))
		if re.search(r"\\[a-zA-Z]+$", out[-1]) and re.match(r"[a-zA-Z]", s[i:i+1]):
			out.append(" ")
	return "".join(out)

def _unwrap(s, cmd):
	"""Replace \\cmd{X} with X."""
	while True:
		m = re.search(r"\\" + cmd + r"(?![a-zA-Z])\s*", s)
		if not m:
			return s
		if m.end() < len(s) and s[m.end()] == "{":
			body, j = group(s, m.end())
		else:
			body, j = _macro_arg(s, m.end())
		s = s[:m.start()] + body + s[j:]

def _mathable(name):
	## Macros that can't go inside math: they make their own, or are layout
	return not re.search(r"\$|\\begin|\\end|\\par\b|skip|space|psfig|\\special|font|obeylines",
		USERMACROS[name][2])

def fix_math(m):
	"""Expand user macros in math, then fix up what pandoc doesn't read."""
	m = expand(m, _mathable)
	m = _unwrap(m, "ensuremath")
	m = re.sub(r"\{\\cal\s*([^{}]*)\}", r"\\mathcal{\1}", m)
	m = re.sub(r"\\cal\s*(\\[a-zA-Z]+|[A-Za-z])", r"\\mathcal{\1}", m)
	m = re.sub(r"\{\\rm\s*([^{}]*)\}", r"\\mathrm{\1}", m)
	return m

def is_math_macro(name):
	"""A user macro meant for text and math alike: it uses \\ensuremath."""
	return (name in USERMACROS and _mathable(name)
		and "ensuremath" in expand("\\" + name, _mathable))

def inline(s):
	"""Convert a run of inline LaTeX to pandoc Markdown."""
	out = []
	i = 0
	while i < len(s):
		c = s[i]
		if s.startswith("$$", i):
			j = s.find("$$", i+2)
			j = len(s) if j < 0 else j
			out.append("\n\n$$" + fix_math(s[i+2:j]).strip() + "$$\n\n")
			i = j+2
		elif c == "$":
			j = s.find("$", i+1)
			if j < 0:
				out.append("\\$"); i += 1; continue
			out.append("$" + fix_math(s[i+1:j]).strip() + "$")
			i = j+1
		elif c == "{":
			body, i = group(s, i)
			m = re.match(r"\s*\\color\{([^}]*)\}\s*", body)
			if m:
				inner = inline(body[m.end():]).strip()
				if inner:
					out.append("[" + inner + "]{." + m.group(1) + "}")
			else:
				out.append(inline(body))
		elif c == "}":
			i += 1
		elif c == "~":
			out.append("\u00a0"); i += 1
		elif c == "%":
			j = s.find("\n", i)
			i = len(s) if j < 0 else j
		elif c == "\\":
			m_start = i
			m = re.match(r"\\([a-zA-Z]+)\*?|\\(.)", s[i:])
			name = m.group(1) or m.group(2)
			i += m.end()
			if name in SYMBOLS:
				out.append(SYMBOLS[name])
			elif is_math_macro(name):
				## Re-read the macro with its arguments, as math
				j = _macro_end(s, name, i)
				out.append("$" + fix_math(s[m_start:j]).strip() + "$")
				i = j
			elif name in DROP0:
				pass
			elif name in DROP1:
				_, _, i = command_args(s, i, 1, 1)
			elif name in WRAP:
				_, reqs, i = command_args(s, i, 0, 1)
				a, b = WRAP[name]
				out.append(a + inline(reqs[0] if reqs else "").strip() + b)
			elif name in ("url",):
				_, reqs, i = command_args(s, i, 0, 1)
				out.append("<" + reqs[0] + ">")
			elif name == "href":
				_, reqs, i = command_args(s, i, 0, 2)
				out.append("[" + inline(reqs[1]) + "](" + reqs[0] + ")")
			elif name == "color":
				_, _, i = command_args(s, i, 0, 1)
			elif name in USERMACROS and _mathable(name):
				## A text macro: expand it (with its arguments) and read the result
				j = _macro_end(s, name, i)
				out.append(inline(expand(s[m_start:j], _mathable)))
				i = j
			else:
				_, reqs, i = command_args(s, i, 0, 1)
				warn("unknown command \\%s (kept its argument)" % name)
				out.append(" ".join(inline(r) for r in reqs))
		else:
			out.append(c); i += 1
	t = "".join(out)
	t = t.replace("---", "—").replace("--", "–")
	t = t.replace("``", "“").replace("''", "”")
	t = re.sub(r"<([0-9+\-]+)>", "", t) # beamer overlay specs
	return t

######################################################################

## Images

IMGEXT = (".pdf", ".png", ".jpg", ".jpeg", ".gif", ".svg")

class Images:
	def __init__(self, texdir, outdir):
		self.texdir = texdir
		self.outdir = outdir
		self.done = {}
		os.makedirs(os.path.join(outdir, "images"), exist_ok=True)

	def get(self, path):
		"""Copy (or convert) an image; return its path relative to outdir."""
		if path in self.done:
			return self.done[path]
		src = os.path.join(self.texdir, path)
		# like graphicx, add an extension unless there's an image one
		if os.path.splitext(src)[1].lower() not in IMGEXT:
			for ext in IMGEXT:
				if os.path.exists(src + ext):
					src += ext; break
		if not (os.path.exists(src) and os.path.splitext(src)[1].lower() in IMGEXT):
			warn("missing image " + path)
			self.done[path] = None
			return None
		base = re.sub(r"[^A-Za-z0-9._-]", "_", path)
		base = re.sub(r"\.(pdf|png|jpe?g|gif|svg)$", "", base, flags=re.I)
		ext = os.path.splitext(src)[1].lower()
		if ext == ".pdf":
			rel = os.path.join("images", base + ".png")
			dest = os.path.join(self.outdir, rel)
			if not os.path.exists(dest) or os.path.getmtime(dest) < os.path.getmtime(src):
				subprocess.run(["pdftoppm", "-png", "-r", "200", "-singlefile",
					src, dest[:-4]], check=True)
		else:
			rel = os.path.join("images", base + ext)
			shutil.copyfile(src, os.path.join(self.outdir, rel))
		self.done[path] = rel
		return rel

######################################################################

## Frames -> Markdown

TOKEN = re.compile(r"""
	\\begin\{(?P<benv>itemize|enumerate|columns|minipage|center)\}
	| \\end\{(?P<eenv>itemize|enumerate|columns|minipage|center)\}
	| \\item(?![a-zA-Z])
	| \\column(?![a-zA-Z])
	| \\includegraphics(?![a-zA-Z])
	| \\frametitle(?![a-zA-Z])
	""", re.X)

def size_attr(opts, target):
	"""Turn includegraphics options into a pandoc attribute string."""
	opt = opts[0] if opts else ""
	m = re.search(r"(width|height)\s*=\s*([0-9.]*)\s*\\(textwidth|textheight|dfheight|linewidth|columnwidth|dfwidth)", opt)
	if not m:
		return ""
	dim, frac = m.group(1), float(m.group(2) or 1)
	if dim == "width":
		frac = min(frac, 1.0)
		if target == "pptx":
			return ""
		return '{width="%d%%"}' % round(100*frac)
	if m.group(3) == "dfheight":
		frac *= 0.8
	if target in ("html", "rmd"):
		return '{style="max-height:%dvh"}' % round(62*frac)
	if target == "typst":
		return '{height="%.1fcm"}' % (11.5*frac)
	return ""

class FrameWriter:
	def __init__(self, images, target):
		self.images = images
		self.target = target

	def convert(self, body):
		self.lines = []      # finished markdown lines
		self.cur = None      # current item/paragraph text (list of str)
		self.indent = ""     # indent of current item line
		self.depth = 0       # list depth
		self.ordered = []    # per list level: enumerate?
		self.mp_open = False # inside an implicit columns block from minipages
		self.cols = 0        # open column divs
		self.has_cols = False
		title = ""
		pos = 0
		toks = list(TOKEN.finditer(body))
		for k, m in enumerate(toks):
			self.text(body[pos:m.start()])
			pos = m.end()
			t = m.group(0)
			if t.startswith("\\frametitle"):
				_, reqs, pos = command_args(body, pos, 0, 1)
				title = inline(reqs[0] if reqs else "").strip()
			elif m.group("benv") in ("itemize", "enumerate"):
				self.flush()
				self.depth += 1
				self.ordered.append(m.group("benv") == "enumerate")
			elif m.group("eenv") in ("itemize", "enumerate"):
				self.flush()
				self.depth -= 1
				self.ordered.pop()
				if self.depth == 0:
					self.lines.append("")
			elif t == "\\item":
				self.flush()
				mark = "1." if self.ordered and self.ordered[-1] else "-"
				self.indent = "    " * (self.depth - 1)
				self.cur = [mark + " "]
				# ANS items look like "\item * {...}"
				rest = body[pos:]
				a = re.match(r"\s*\*\s*(?=\{)", rest)
				if a:
					pos += a.end()
			elif m.group("benv") == "columns":
				_, _, pos = command_args(body, pos, 1, 0)
				self.open_columns()
			elif m.group("eenv") == "columns":
				self.close_column()
				self.close_columns()
			elif t == "\\column":
				_, reqs, pos = command_args(body, pos, 0, 1)
				self.close_column()
				self.open_column(reqs[0] if reqs else "")
			elif m.group("benv") == "minipage":
				_, reqs, pos = command_args(body, pos, 1, 1)
				if not self.mp_open:
					self.open_columns()
					self.mp_open = True
				self.open_column(reqs[0] if reqs else "")
			elif m.group("eenv") == "minipage":
				self.close_column()
				nxt = toks[k+1] if k+1 < len(toks) else None
				between = body[pos:nxt.start()] if nxt else body[pos:]
				between = re.sub(r"\\hspace\{[^}]*\}|\s", "", between)
				if not (nxt and nxt.group("benv") == "minipage" and not between):
					self.close_columns()
					self.mp_open = False
			elif m.group("benv") or m.group("eenv"):
				self.flush()
			elif t == "\\includegraphics":
				opts, reqs, pos = command_args(body, pos, 1, 1)
				rel = self.images.get(reqs[0].strip()) if reqs else None
				if rel:
					img = "![](%s)%s" % (rel, size_attr(opts, self.target))
					if self.cur is not None:
						self.cur.append(img)
					else:
						self.lines += ["", img, ""]
		self.text(body[pos:])
		self.flush()
		while self.cols:
			self.close_column()
		md = "\n".join(self.lines)
		md = re.sub(r"\n{3,}", "\n\n", md).strip("\n")
		return title, md

	def text(self, s):
		s = inline(s)
		if self.cur is not None:
			if s.strip():
				self.cur.append(" ".join(s.split()))
			return
		for para in re.split(r"\n\s*\n", s):
			para = " ".join(para.split())
			if para:
				self.lines += ["", para, ""]

	def flush(self):
		if self.cur is not None:
			line = self.cur[0] + " ".join(x for x in self.cur[1:] if x)
			self.lines.append(self.indent + line.rstrip())
			self.cur = None

	def open_columns(self):
		self.flush()
		self.has_cols = True
		self.lines += ["", ":::::: columns"]

	def close_columns(self):
		self.flush()
		self.lines += ["::::::", ""]

	def open_column(self, width):
		self.flush()
		m = re.match(r"\s*([0-9.]*)\s*\\(textwidth|linewidth|dfwidth)", width)
		frac = float(m.group(1) or 1) if m else 0.47
		if m and m.group(2) == "dfwidth":
			frac = 0.47
		self.lines += ["", '::: {.column width="%d%%"}' % round(100*frac), ""]
		self.cols += 1

	def close_column(self):
		self.flush()
		if self.cols:
			self.lines += ["", ":::", ""]
			self.cols -= 1

######################################################################

## Whole document

def macros(tex):
	"""Last definition of each \\newcommand/\\renewcommand without args."""
	d = {}
	for m in re.finditer(r"\\(?:re)?newcommand\{?\\([a-zA-Z]+)\}?(?=\{)", tex):
		body, _ = group(tex, m.end())
		d[m.group(1)] = body
	return d

def parse(tex, texdir=None):
	"""Return (meta, items) where items are ('sec', level, title) or ('frame', body).

	texdir is where latex runs, for finding the user's macro files."""
	load_macros(tex, texdir)
	m = re.search(r"\\begin\{document\}(.*?)\\end\{document\}", tex, re.S)
	body = m.group(1) if m else tex
	defs = macros(body)
	meta = {}
	for key, name in (("title", "jdtitle"), ("subtitle", "jdsub"), ("author", "jdauth")):
		v = defs.get(name, "")
		v = inline(v).strip()
		if v:
			meta[key] = v
	items = []
	pat = re.compile(r"\\begin\{frame\}(\[[^\]]*\])?(.*?)\\end\{frame\}|\\(sub)?section\*?\{", re.S)
	for m in pat.finditer(body):
		if m.group(0).startswith("\\begin"):
			items.append(("frame", m.group(2)))
		else:
			title, _ = group(body, m.end()-1)
			items.append(("sec", 2 if m.group(3) else 1, inline(title).strip()))
	return meta, items

def yaml_str(s):
	return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'

def markdown(meta, items, images, target):
	fw = FrameWriter(images, target)
	out = []
	for it in items:
		if it[0] == "sec":
			# Subsections become title-only slides (slide level is 2)
			out.append("%s %s\n" % ("#" * it[1], it[2]))
			continue
		title, md = fw.convert(it[1])
		if not title and not md:
			continue
		pics = re.findall(r"^!\[\].*$", md, flags=re.M)
		if target == "pptx" and pics and not fw.has_cols:
			# pandoc splits text-image-text slides; use text | image instead
			text = re.sub(r"^!\[\].*$", "", md, flags=re.M).strip()
			if text:
				md = (":::::: columns\n\n::: column\n\n%s\n\n:::\n\n::: column\n\n%s\n\n:::\n\n::::::"
					% (text, "\n\n".join(pics)))
		if target == "rmd" and fw.has_cols:
			# ioslides wants columns as a slide class, not divs
			md = re.sub(r"^:::.*$", "", md, flags=re.M)
			md = re.sub(r"\n{3,}", "\n\n", md).strip("\n")
			out.append("## %s {.columns-2}\n\n%s\n" % (title, md))
		elif title:
			out.append("## %s\n\n%s\n" % (title, md))
		else:
			out.append("----\n\n%s\n" % md)
	return "\n".join(out)

######################################################################

## Writers

LUA_TYPST = r"""
-- columns -> grid; horizontal rule -> page break; answers in colour
function Div(el)
  if el.classes:includes("columns") then
    local widths, blocks = {}, {}
    for _, col in ipairs(el.content) do
      if col.t == "Div" then
        local w = col.attributes.width or "47%"
        table.insert(widths, (w:gsub("%%", "fr")))
        table.insert(blocks, pandoc.RawBlock("typst", "["))
        for _, b in ipairs(col.content) do table.insert(blocks, b) end
        table.insert(blocks, pandoc.RawBlock("typst", "],"))
      end
    end
    table.insert(blocks, 1, pandoc.RawBlock("typst",
      "#grid(columns: (" .. table.concat(widths, ", ") .. "), gutter: 1.2em, align: horizon,"))
    table.insert(blocks, pandoc.RawBlock("typst", ")"))
    return blocks
  end
end
function Image(el)
  -- pandoc's own output boxes the image without scaling it
  local args = {}
  for _, k in ipairs({"width", "height"}) do
    if el.attributes[k] then table.insert(args, k .. ": " .. el.attributes[k]) end
  end
  if #args == 0 then args = {"width: 100%", "height: 11cm", 'fit: "contain"'} end
  return pandoc.RawInline("typst",
    '#image("' .. el.src .. '", ' .. table.concat(args, ", ") .. ')')
end
function HorizontalRule()
  return pandoc.RawBlock("typst", "#pagebreak(weak: true)")
end
function Span(el)
  if #el.classes > 0 then
    return {pandoc.RawInline("typst", "#text(fill: " .. el.classes[1] .. ")["),
      el, pandoc.RawInline("typst", "]")}
  end
end
"""

TYPST_PRE = """\
#set page(width: 25.4cm, height: 19.05cm, margin: (x: 1.6cm, top: 1.2cm, bottom: 1.2cm),
  footer: context align(right, text(size: 12pt, fill: gray, counter(page).display())))
#set text(size: 22pt, font: ("Libertinus Serif", "New Computer Modern", "DejaVu Sans"))
#show math.equation: set text(font: ("New Computer Modern Math"))
#set list(spacing: 0.75em, indent: 0.4em)
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  v(1fr); align(center, text(size: 34pt, fill: rgb("#1f3c88"), it.body)); v(1fr)
  pagebreak(weak: true)
}
#show heading.where(level: 2): it => {
  pagebreak(weak: true)
  block(below: 0.8em, text(size: 26pt, fill: rgb("#1f3c88"), it.body))
}
#show image: set align(center)

#align(center + horizon)[
  #text(size: 34pt, fill: rgb("#1f3c88"))[%(title)s]
  #v(0.4em)
  #text(size: 22pt)[%(subtitle)s]
  #v(1.2em)
  #text(size: 18pt)[%(author)s]
]
"""

def pandoc(args, md, cwd):
	subprocess.run(["pandoc", "-f", "markdown"] + args, input=md.encode(),
		cwd=cwd, check=True)

######################################################################

## pptx math fallback

## pandoc puts any text box with an equation inside
## <mc:AlternateContent><mc:Choice Requires="a14">, with no <mc:Fallback>, so
## viewers without Office 2010 math (LibreOffice, Google Slides, Keynote ...)
## drop the whole box. We add a Fallback: the same box, with each equation
## written as ordinary text runs (sub/superscripts as baseline shifts).

OMML = "http://schemas.openxmlformats.org/officeDocument/2006/math"
A14 = "http://schemas.microsoft.com/office/drawing/2010/main"

def _m(tag):
	return "{%s}%s" % (OMML, tag)

def _prop(el, prop, attr="val", default=None):
	"""The m:val of el's m:xxxPr/m:prop child, if any."""
	for pr in el:
		if pr.tag.endswith("Pr"):
			c = pr.find(_m(prop))
			if c is not None:
				return c.get(_m(attr), default)
	return default

## Unicode math alphabets (\mathcal etc.): capital A, small a, exceptions
ALPHABETS = {
	"script": (0x1D49C, 0x1D4B6, {"B": "ℬ", "E": "ℰ", "F": "ℱ", "H": "ℋ", "I": "ℐ",
		"L": "ℒ", "M": "ℳ", "R": "ℛ", "e": "ℯ", "g": "ℊ", "o": "ℴ"}),
	"double-struck": (0x1D538, 0x1D552, {"C": "ℂ", "H": "ℍ", "N": "ℕ", "P": "ℙ",
		"Q": "ℚ", "R": "ℝ", "Z": "ℤ"}),
	"fraktur": (0x1D504, 0x1D51E, {"C": "ℭ", "H": "ℌ", "I": "ℑ", "R": "ℜ", "Z": "ℨ"}),
}

RELATIONS = set("=<>≤≥≈≠→⇒∝")

def _letter(alphabet, c):
	cap, small, exc = ALPHABETS[alphabet]
	if c in exc:
		return exc[c]
	if "A" <= c <= "Z":
		return chr(cap + ord(c) - ord("A"))
	if "a" <= c <= "z":
		return chr(small + ord(c) - ord("a"))
	return c

def _omml_runs(el, base=0):
	"""Linearize an OMML element to [(text, baseline, italic)]."""
	tag = el.tag.split("}")[-1]
	kids = lambda name: [c for c in el if c.tag == _m(name)]
	sub = lambda name, b: [x for c in kids(name) for x in _omml_runs(c, b)]
	def plain(t):
		return [(t, base, False)]
	def wrap(runs):
		## Parenthesize a fraction part with more than one character
		t = "".join(r[0] for r in runs)
		return plain("(") + runs + plain(")") if len(t) > 1 else runs
	if tag == "r":
		t = "".join(x.text or "" for x in el.iter(_m("t")))
		sty = _prop(el, "sty", default="i")
		scr = _prop(el, "scr")
		if scr in ALPHABETS:
			return [("".join(_letter(scr, c) for c in t), base, False)]
		if t in RELATIONS:
			t = " " + t + " "
		return [(t, base, sty in ("i", "bi") and t.isalpha())]
	if tag in ("sSub", "sSup", "sSubSup", "sPre"):
		lo, hi = base - 25000, base + 30000
		scripts = sub("sub", lo) + sub("sup", hi)
		return (scripts + sub("e", base)) if tag == "sPre" else (sub("e", base) + scripts)
	if tag == "f":
		return wrap(sub("num", base)) + plain("/") + wrap(sub("den", base))
	if tag == "d":
		beg = _prop(el, "begChr", default="(")
		end = _prop(el, "endChr", default=")")
		sep = _prop(el, "sepChr", default=",")
		out = plain(beg)
		for k, e in enumerate(kids("e")):
			if k:
				out += plain(sep)
			out += _omml_runs(e, base)
		return out + plain(end)
	if tag == "rad":
		return plain("√(") + sub("e", base) + plain(")")
	if tag == "nary":
		return (plain(_prop(el, "chr", default="∫")) + sub("sub", base - 25000)
			+ sub("sup", base + 30000) + sub("e", base))
	if tag in ("acc", "bar"):
		mark = _prop(el, "chr", default="̂") if tag == "acc" else "̅"
		e = sub("e", base)
		if e:
			t, b, i = e[-1]
			e[-1] = (t + mark, b, i)
		return e
	if tag in ("limLow", "limUpp"):
		return sub("e", base) + sub("lim", base + (-25000 if tag == "limLow" else 30000))
	if tag == "eqArr":
		out = []
		for k, e in enumerate(kids("e")):
			out += (plain("; ") if k else []) + _omml_runs(e, base)
		return out
	if tag.endswith("Pr"):
		return []
	return [x for c in el for x in _omml_runs(c, base)]

def _runs_xml(runs):
	out = []
	for t, b, i in runs:
		if not t:
			continue
		if out and out[-1][1:] == (b, i):
			out[-1] = (out[-1][0] + t, b, i)
		else:
			out.append((t, b, i))
	xml = []
	for t, b, i in out:
		attrs = (' baseline="%d"' % b if b else "") + (' i="1"' if i else "")
		xml.append('<a:r><a:rPr%s/><a:t>%s</a:t></a:r>' % (attrs, escape(t)))
	return "".join(xml)

def _math_to_runs(m):
	frag = m.group(0)
	wrapped = '<w xmlns:a14="%s" xmlns:m="%s">%s</w>' % (A14, OMML, frag)
	try:
		root = ET.fromstring(wrapped)
	except ET.ParseError:
		return ""
	return _runs_xml(_omml_runs(root))

ALTPAT = re.compile(r'<mc:AlternateContent\b[^>]*>\s*(<mc:Choice\b[^>]*Requires="a14"[^>]*>)(.*?)</mc:Choice>\s*</mc:AlternateContent>', re.S)
MATHPAT = re.compile(r"<a14:m>.*?</a14:m>", re.S)

def _add_fallback(m):
	fallback = MATHPAT.sub(_math_to_runs, m.group(2))
	return m.group(0).replace("</mc:AlternateContent>",
		"<mc:Fallback>" + fallback + "</mc:Fallback></mc:AlternateContent>")

def pptx_fallback(path):
	"""Add text Fallbacks for a14 math to every slide of the pptx at path."""
	tmp = path + ".tmp"
	with zipfile.ZipFile(path) as zin, zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as zout:
		for item in zin.infolist():
			data = zin.read(item.filename)
			if re.match(r"ppt/slides/slide\d+\.xml$", item.filename):
				x = data.decode("utf-8")
				if "<mc:Fallback" not in x:
					x = ALTPAT.sub(_add_fallback, x)
				## pandoc also puts bare a14 math (in titles, with the namespace
				## undeclared, which isn't valid XML); make it text
				parts = re.split(r"(<mc:AlternateContent\b.*?</mc:AlternateContent>)", x, flags=re.S)
				x = "".join(q if q.startswith("<mc:Alt") else MATHPAT.sub(_math_to_runs, q)
					for q in parts)
				data = x.encode("utf-8")
			zout.writestr(item, data)
	os.replace(tmp, path)

def write(path, s):
	with open(path, "w") as f:
		f.write(s)

def header(meta, extra):
	y = ["---"] + ["%s: %s" % (k, yaml_str(v)) for k, v in meta.items()]
	return "\n".join(y + extra + ["---", "", ""])

def main():
	ap = argparse.ArgumentParser(description=__doc__,
		formatter_class=argparse.RawDescriptionHelpFormatter)
	ap.add_argument("tex", help="generated talk file, e.g. evaluation.slides.tex")
	ap.add_argument("--pdf", help="compiled PDF, for the pixel-perfect .pix.pptx")
	ap.add_argument("--outdir", help="default: <stem>_export")
	ap.add_argument("--formats", default="pptx,qmd,rmd,typst",
		help="comma-separated subset of pptx,qmd,rmd,typst")
	ap.add_argument("--reference-doc", help="pptx template for pandoc")
	ap.add_argument("--render", action="store_true",
		help="also render .qmd to .html and .typ to .pdf (needs quarto)")
	ap.add_argument("--zip", action="store_true", help="zip the output folder")
	a = ap.parse_args()

	stem = os.path.basename(a.tex)
	stem = stem[:-4] if stem.endswith(".tex") else stem
	outdir = os.path.abspath(a.outdir or stem + "_export")
	os.makedirs(outdir, exist_ok=True)
	with open(a.tex) as f:
		tex = f.read()
	meta, items = parse(tex, os.path.dirname(os.path.abspath(a.tex)))
	images = Images(os.path.dirname(os.path.abspath(a.tex)), outdir)
	formats = a.formats.split(",")

	write(os.path.join(outdir, stem + ".md"),
		header(meta, []) + markdown(meta, items, images, "html"))

	if "pptx" in formats:
		md = header(meta, []) + markdown(meta, items, images, "pptx")
		ref = ["--reference-doc", os.path.abspath(a.reference_doc)] if a.reference_doc else []
		pandoc(["-t", "pptx", "--slide-level", "2", "-o", stem + ".pptx"] + ref,
			md, outdir)
		pptx_fallback(os.path.join(outdir, stem + ".pptx"))
		if a.pdf:
			pix = os.path.join(outdir, "pages")
			shutil.rmtree(pix, ignore_errors=True)
			os.makedirs(pix)
			subprocess.run(["pdftoppm", "-png", "-r", "200",
				os.path.abspath(a.pdf), os.path.join(pix, "p")], check=True)
			pages = sorted(os.listdir(pix))
			md = header(meta, []) + "\n".join(
				"----\n\n![](pages/%s)\n" % p for p in pages)
			pandoc(["-t", "pptx", "-o", stem + ".pix.pptx"], md, outdir)
			shutil.rmtree(pix)

	if "qmd" in formats:
		md = header(meta, [
			"format:",
			"  revealjs:",
			"    embed-resources: true",
			"    slide-number: true",
			"    css: talk.css",
			"  pptx: default",
			"  # beamer: default",
		]) + markdown(meta, items, images, "html")
		write(os.path.join(outdir, stem + ".qmd"), md)
		write(os.path.join(outdir, "talk.css"),
			".blue, .answer { color: #1f4e9c; }\n.red { color: #b22; }\n")

	if "rmd" in formats:
		md = header(meta, [
			"output:",
			"  ioslides_presentation:",
			"    self_contained: true",
			"    css: talk.css",
			"  # powerpoint_presentation: default",
			"  # beamer_presentation: default",
		]) + markdown(meta, items, images, "rmd")
		write(os.path.join(outdir, stem + ".Rmd"), md)
		write(os.path.join(outdir, "talk.css"),
			".blue, .answer { color: #1f4e9c; }\n.red { color: #b22; }\n")

	if "typst" in formats:
		md = markdown(meta, items, images, "typst")
		with tempfile.NamedTemporaryFile("w", suffix=".lua", delete=False) as f:
			f.write(LUA_TYPST)
			lua = f.name
		try:
			body = subprocess.run(["pandoc", "-f", "markdown", "-t", "typst",
				"--lua-filter", lua], input=md.encode(), cwd=outdir,
				check=True, capture_output=True).stdout.decode()
		finally:
			os.unlink(lua)
		def esc(s):
			return re.sub(r"([#\[\]*_$@<`\\])", r"\\\1", s)
		pre = TYPST_PRE % {k: esc(meta.get(k, "")) for k in ("title", "subtitle", "author")}
		write(os.path.join(outdir, stem + ".typ"), pre + "\n" + body)

	if a.render:
		if "qmd" in formats:
			subprocess.run(["quarto", "render", stem + ".qmd", "--to", "revealjs"],
				cwd=outdir, check=True)
		if "typst" in formats:
			subprocess.run(["quarto", "typst", "compile", stem + ".typ"],
				cwd=outdir, check=True)

	if a.zip:
		shutil.make_archive(outdir, "zip", os.path.dirname(outdir),
			os.path.basename(outdir))
	print("talkexport: wrote " + outdir)

if __name__ == "__main__":
	main()
