## texk: latex with a flat, recursively-scanned dependency file
## Replaces texj; see texk.md

latexEngine ?= pdflatex
latexNonstop ?= -interaction=nonstopmode
latexJob = -jobname=$(basename $@)
bibtex ?= biber $* || bibtex $*

runLatex = $(latexEngine) $(latexJob) $*
RUNLatex = $(latexEngine) $(latexNonstop) $(latexJob) $*

######################################################################

## Dependencies

## One file per document, covering everything \input from it at any depth
## Only loaded by the sub-make below, never by the main Makefile
.PRECIOUS: %.texk.mk
%.texk.mk: %.tex makestuff/texk.pl
	perl -wf makestuff/texk.pl $< > $@

## Touched when anything the document depends on changes
.PRECIOUS: %.tex.deps
%.tex.deps:
	$(touch)

######################################################################

## Basic pathway

## The main .pdf is never up to date, because the main Makefile doesn't
## know the dependencies; the sub-make does nothing if they haven't changed
.PRECIOUS: %.pdf
%.pdf: %.tex phony
	$(MAKE) -f $*.texk.mk -f Makefile $*.repeat

## First pass; can fail (e.g., missing pictures or references)
.PRECIOUS: %.aux
%.aux: %.tex
	- $(RUNLatex)

## Deps first, so that pictures exist before latex runs
%.repeat: %.tex.deps %.aux
	$(runLatex)
	$(touch)
	@(grep "Rerun to" $*.log && touch $*.aux) || echo latex refs up to date

%.bbl: %.tex
	$(rm)
	$(MAKE) $*.aux
	$(bibtex)

phony: ;

## Run through errors if possible
Ignore += *.force.pdf
%.force.pdf: force
	$(MAKE) $*.pdf || $(MAKE) $*.aux
	$(CP) $*.pdf $@
force:

## Loop over reruns, until latex stops asking (at most 5 times)
## make -q is not a reliable test here (included makefiles, hot directories)
%.texfinal: phony
	@for i in 1 2 3 4 5; do \
		$(MAKE) $*.pdf || exit 1; \
		grep -q "Rerun to" $*.log || exit 0; \
	done; echo "$*: latex still asking for reruns"; exit 1

%.texfinal.pdf: %.texfinal
	$(CP) $*.pdf $@

######################################################################

## Won't usually work, but shouldn't cause any problems
## (no prereq)

comments.tex comments.TEX: ../LatexTemplates/comments.tex
	$(copy)

######################################################################

texfiles = $(wildcard *.tex */*.tex)
Ignore += $(texfiles:tex=pdf)
Ignore += $(texfiles:tex=out)

Ignore += *.biblog *.log *.aux .*.aux *.blg *.bbl *.bcf *.repeat *.texfinal
Ignore += *.nav *.snm *.toc *.ptc
Ignore += *.run.xml
Ignore += *.tex.* *.TEX.* *.texk.mk
Ignore += *.aux.pdf *.aux.out *.texfinal.pdf *.out

jclean:
	$(RM) *.biblog *.log *.aux .*.aux *.blg *.bbl *.bcf *.repeat *.complete *.texk.mk
