## Export newtalk beamer talks to formats other people can use
## See makestuff/workshops.md

## Editable pptx, in this directory
## evaluation.slides.pptx:
Ignore += *.pptx
%.pptx: %.tex makestuff/workshops/talkpptx.py makestuff/workshops/talkexport.py
	python3 makestuff/workshops/talkpptx.py $<

## Everything (pptx, pixel pptx, qmd, Rmd, typst), in a folder and a zip
## evaluation.slides.export:
Ignore += *_export/ *_export.zip
%.export: %.tex %.pdf makestuff/workshops/talkexport.py
	python3 makestuff/workshops/talkexport.py $< --pdf $*.pdf --render --zip
