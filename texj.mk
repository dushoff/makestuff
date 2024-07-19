latexEngine ?= pdflatex
latexNonstop ?= -interaction=nonstopmode
latexJob = -jobname=$(basename $@)
bibtex ?= biber $* || bibtex $*

runLatex = $(latexEngine) $(latexJob) $(basename $<)
RUNLatex = $(latexEngine) $(latexNonstop) $(latexJob) $(basename $<)

######################################################################

## Basic pathway

.PRECIOUS: %.aux
%.aux: %.tex
	- $(RUNLatex)

%.repeat: %.aux %.tex.deps
	-$(MAKE) -f $*.tex.mk -f Makefile $*.tex.deps
	$(runLatex)
	$(touch)
	sleep 1
	@(grep "Rerun to" $*.log && touch $<) || echo latex refs up to date

## The main .pdf should never be up to date
## because Makefile can't evaluate whether the deps are up to date
%.pdf: %.aux phony
	$(MAKE) -f $*.tex.mk -f Makefile $*.tex.deps
	$(MAKE) $*.repeat

%.bbl: %.tex 
	$(rm)
	$(MAKE) $*.aux
	$(bibtex)

phony: ;

## This rule meant to be over-ridden by rules in the corresponding .mk
.PRECIOUS: %.tex.deps
%.tex.deps:
	touch $@

######################################################################

## Loop over reruns

%.complete: phony
	@while ! $(MAKE) -q $*.repeat ; do $(MAKE) $*.repeat; done;

%.complete.pdf: %.complete
	$(CP) $*.pdf $@

######################################################################

.PRECIOUS: %.tex.mk
%.tex.mk: %.tex 
	perl -wf makestuff/texi.pl $< > $@

######################################################################

texfiles = $(wildcard *.tex)
Ignore += $(texfiles:tex=pdf)
Ignore += $(texfiles:tex=out)

## These direct exclusions can be replaced by fancier rules above if necessary
Ignore += *.biblog *.log *.aux .*.aux *.blg *.bbl *.bcf *.repeat *.complete
Ignore += *.nav *.snm *.toc
Ignore += *.run.xml
Ignore += *.tex.* *.subdeps *.makedeps
Ignore += *.aux.pdf *.aux.out *.complete.pdf
