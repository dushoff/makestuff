
## Draft version; just make it. Will sometimes report an error even when a pdf is made; this should be fixed maybe.
## Note that it will loop forever if no pdf is made, but stop making if it makes one. Thus making vtarget twice will work when it's supposed to.
%.tex.pdf: %.tex
	$(texir) || $(latexnonly) || $(latexonly)

%.TEX.pdf: %.TEX
	$(texir) || $(latexnonly) || $(latexonly)

%.tikz.pdf: %.tikz
	$(latexonly) || $(latexnonly)

## .pdf is never up to date (makedeps is fake)
## Why is extra makedeps needed? Implicit rule recursion is confusing
%.pdf: %.tex %.tex.deps %.makedeps makedeps
	$(MAKE) $*.deps.pdf

## Working on work flow choices 2021 Oct 20 (Wed)
## Using latexonly to jump to tex error; touch to keep make chain going
## But .deps.pdf can be up to date (if .tex.deps didn't need anything)
%.deps.pdf: %.tex %.tex.deps
	$(texir) || ($(latexonly) && touch $<)
	$(CP) $@ $*.pdf 

## This rule meant to be over-ridden by rules in the corresponding .mk
## Helps with dependency logic above
.PRECIOUS: %.tex.deps
%.tex.deps:
	touch $@

# A phony target (this is how .tex.deps is "really" made)
%.makedeps: %.tex.mk %.tex
	$(MAKE) -f $< -f Makefile $*.subdeps
	$(MAKE) -f $< -f Makefile $*.tex.deps

## Must not exist!
makedeps: ;

.PRECIOUS: %.tex.mk
%.tex.mk: %.tex 
	perl -wf makestuff/texi.pl $< > $@

## Include logic is still a bit tangled (sad face)

## We need ugly logic here because texi doesn't respond to changes in .bib
%.bbl: %.tex %.tex.pdf $(wildcard *.bib)
	($(bibtex)) || ($(RM) $@ && false)

texfiles = $(wildcard *.tex)
Ignore += $(texfiles:tex=pdf)
Ignore += $(texfiles:tex=out)

## These direct exclusions can be replaced by fancier rules above if necessary
Ignore += *.biblog *.log *.aux .*.aux *.blg *.bbl *.bcf 
Ignore += *.nav *.snm *.toc
Ignore += *.run.xml
Ignore += *.tex.* *.subdeps *.makedeps
Ignore += *.deps.pdf *.deps.out

### Doesn't quite fit here (or anywhere)

ifndef PUSH
-include makestuff/perl.def
endif

Ignore += $(wildcard *_olddiff.*)
.PRECIOUS: %_olddiff.tex
%_olddiff.tex: %.tex.*.oldfile %.tex makestuff/latexdiff.pl
	$(PUSH)
