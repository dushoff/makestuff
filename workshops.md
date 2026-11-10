# workshops.mk: exporting talks

Tools for giving newtalk (beamer) talks to people who want PowerPoint,
Quarto, R Markdown or Typst instead of a PDF.

Use with `-include makestuff/workshops.mk` (and `texk.mk`, for dependencies). Needs `python3`, `pandoc` and `pdftoppm`;
`.export` also uses `quarto` (which bundles typst).

## Targets

* `foo.slides.pptx` – an editable PowerPoint, made next to `foo.slides.tex`
  (works for any version: `.slides`, `.final`, `.draft` …)
* `foo.slides.export` – makes `foo.slides_export/` and `foo.slides_export.zip` with:
	* `.pptx` – editable PowerPoint
	* `.pix.pptx` – one picture per page of the PDF; looks exactly like the talk, but not editable
	* `.qmd` and rendered `.html` – Quarto, reveal.js by default (self-contained)
	* `.Rmd` – R Markdown, ioslides by default (self-contained)
	* `.typ` and rendered `.pdf` – Typst, no packages needed
	* `.md` – the pandoc Markdown for the HTML formats (for reference; nothing is built from it)
	* `images/` – every figure, PDFs converted to PNG

## How it works

The scripts read the generated `.tex`, not the `.txt`, so whatever venue
format is set (e.g., `make daidd.set`) is already applied. 

`workshops/talkexport.py` parses the beamer frames (titles, `itemize`/`enumerate`,
`columns`, `minipage` pairs, `\includegraphics`, sections) into slides, and writes
slightly different pandoc Markdown for each target. Every output is built
directly from the `.tex` – `foo.pptx` is not made from `foo.md`.
`workshops/talkpptx.py` is a small wrapper that uses the same parser to make
only the `.pptx`.

`.export` overwrites its whole folder, so don't edit the `.qmd`, `.Rmd` or `.typ` there
without copying them somewhere else.

## Limitations

* Equations in the editable pptx are real PowerPoint equations. Other viewers
  (LibreOffice, Google Slides, Keynote) can't read those, so each one also gets a plain-text
  version (sub/superscripts, script letters) that they show instead; before this, pandoc's
  output made them drop the whole text box. Equations in slide titles are always plain text
* Coloured text (e.g., `ANS` answers) survives in Quarto, R Markdown and Typst,
  but not in the editable pptx
* Figures are scaled to fit, not to the exact beamer sizes
* TikZ, tables, and overlays (`\uncover`, `\pause`) come through roughly or not at all;
  the script warns about commands it doesn't recognize
* Quarto and R Markdown both render to `foo.slides.html`; rendering one overwrites the other
* User macros are read from the files the talk loads locally (`\usepackage{talkdir/commands}`,
  `\input`) and from the talk itself, and expanded, with arguments. In math, a macro is
  expanded unless it is layout (or makes its own `$`); in text, `\ensuremath` macros become
  math, and other harmless macros are expanded as text. `\ensuremath` is dropped and
  `{\cal X}` becomes `\mathcal{X}`. Macros that aren't defined anywhere the talk can see
  are warned about, as before

## Future

Maybe make a single editable `.md` the source, and build the other formats from it with
pandoc Lua filters, instead of from the `.tex`.
