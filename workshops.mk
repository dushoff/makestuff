## Export newtalk beamer talks to formats other people can use
## See makestuff/workshops.md

## Editable pptx, in this directory
## evaluation.slides.pptx:
## Like %.pdf in texk.mk, a sub-make reads the dependencies (pictures,
## macro files like talkdir/commands.sty) from %.texk.mk
Ignore += *.pptx *.pptxmade
.PRECIOUS: %.pptx
%.pptx: %.tex phony
	$(MAKE) -f $*.texk.mk -f Makefile $*.pptxmade

%.pptxmade: %.tex %.tex.deps makestuff/workshops/talkpptx.py makestuff/workshops/talkexport.py
	python3 makestuff/workshops/talkpptx.py $<
	$(touch)

## Everything (pptx, pixel pptx, qmd, Rmd, typst), in a folder and a zip
## evaluation.slides.export:
Ignore += *_export/ *_export.zip
%.export: %.tex %.pdf makestuff/workshops/talkexport.py
	python3 makestuff/workshops/talkexport.py $< --pdf $*.pdf --render --zip
