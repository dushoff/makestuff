latexEngine ?= pdflatex
latexNonstop ?= -interaction=nonstopmode
latexJob = -jobname=$(basename $@)
bibtex ?= biber $* || bibtex $*

runLatex = $(latexEngine) $(latexJob) $(basename $<)
RUNLatex = $(latexEngine) $(latexNonstop) $(latexJob) (basename $<)

%.aux: %.tex
	$(runLatex)
	$(MV) $*.pdf $*.aux.pdf

## This .pdf should never be up to date
## because Makefile can't evaluate whether the deps are up to date
%.pdf: phony
	$(MAKE) -f $*.tex.mk -f Makefile $*.tex.deps
	$(MAKE) $*.aux
	$(CP) $*.aux.pdf $@

%.bbl: %.aux 
	$(rm)
	$(bibtex)

phony: ;

.PRECIOUS: %.tex.mk
%.tex.mk: %.tex 
	perl -wf makestuff/texi.pl $< > $@

texfiles = $(wildcard *.tex)
Ignore += $(texfiles:tex=pdf)
Ignore += $(texfiles:tex=out)

## These direct exclusions can be replaced by fancier rules above if necessary
Ignore += *.biblog *.log *.aux .*.aux *.blg *.bbl *.bcf 
Ignore += *.nav *.snm *.toc
Ignore += *.run.xml
Ignore += *.tex.* *.subdeps *.makedeps
Ignore += *.deps.pdf *.deps.out
