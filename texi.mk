latex = pdflatex -interaction=nonstopmode
texi = texi2pdf
job = -jobname=$(@:%.pdf=%)

texir = $(texi) -o $@ $<
latexonly = $(latex) $(job) $<

ifeq ($(bibtex),)
bibtex = biber $* || bibtex $*
endif

## Draft version; just make it. Will sometimes report an error even when a pdf is made; this should be fixed maybe.
## Note that it will loop forever if no pdf is made, but stop making if it makes one. Thus making vtarget twice will work when it's supposed to.
%.tex.pdf: %.tex
	$(texir) || $(latexonly)

## .pdf is never up to date (makedeps is fake)
## Why is extra makedeps needed? Implicit rule recursion is confusing
%.pdf: %.tex %.tex.deps %.makedeps makedeps
	$(MAKE) $*.deps.pdf

## But .deps.pdf can be up to date (if .tex.deps didn't need anything)
%.deps.pdf: %.tex %.tex.deps
	$(texir)
	$(CP) $@ $*.pdf 

## This rule meant to be over-ridden by rules in the corresponding .mk
## Helps with dependency logic above
.PRECIOUS: %.tex.deps
%.tex.deps:
	touch $@

# A phony target (this is how .tex.deps is "really" made)
%.makedeps: %.tex.mk %.tex
	$(MAKE) -f $< -f Makefile $*.tex.deps

## Must not exist!
makedeps: ;

.PRECIOUS: %.tex.mk
%.tex.mk: %.tex 
	perl -wf makestuff/texi.pl $< > $@

## Current recompiling logic depends on this, and may lead to some extra work
## The simple fix didn't work (texi wasn't smart enough??)
%.bbl: %.tex $(wildcard *.bib)
	($(bibtex)) || ($(RM) $@ && false)
