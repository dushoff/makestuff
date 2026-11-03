#!/usr/bin/env python3
"""Make an editable foo.pptx next to foo.tex (a generated talkdir beamer talk).

	python3 talkpptx.py evaluation.slides.tex   # -> evaluation.slides.pptx

Uses the parser in talkexport.py; images go in a temporary folder and are
embedded in the .pptx. Needs pandoc and pdftoppm.
"""

import os
import sys
import tempfile

from talkexport import Images, header, markdown, pandoc, parse

def main():
	if len(sys.argv) != 2 or not sys.argv[1].endswith(".tex"):
		sys.exit(__doc__)
	tex = os.path.abspath(sys.argv[1])
	out = tex[:-4] + ".pptx"
	with open(tex) as f:
		meta, items = parse(f.read())
	with tempfile.TemporaryDirectory() as tmp:
		images = Images(os.path.dirname(tex), tmp)
		md = header(meta, []) + markdown(meta, items, images, "pptx")
		pandoc(["-t", "pptx", "--slide-level", "2", "-o", out], md, tmp)
	print("talkpptx: wrote " + out)

if __name__ == "__main__":
	main()
