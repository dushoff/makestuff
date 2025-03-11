latexEngine ?= pdflatex
latexNonstop ?= -interaction=nonstopmode
latexJob = -jobname=$(basename $@)
bibtex ?= biber $* || bibtex $*

runLatex = $(latexEngine) $(latexJob) $(basename $<)
RUNLatex = $(latexEngine) $(latexNonstop) $(latexJob) $(basename $<)

######################################################################

## Basic pathway

.PRECIOUS: %.aux
%.aux: %.tex | %.texdeps.mk
	- $(RUNLatex)

## May need to make recipes and repeat these two with TEX ☹
## Or these three
%.repeat: %.aux %.tex.deps
	-$(MAKE) -f $*.texdeps.mk -f Makefile $*.tex.deps
	$(runLatex)
	$(touch)
	## sleep 1
	@(grep "Rerun to" $*.log && touch $<) || echo latex refs up to date

## The main .pdf should never be up to date
## because Makefile alone can't evaluate whether the deps are up to date
.PRECIOUS: %.pdf
%.pdf: %.aux phony
	$(MAKE) -f $*.tex.mk -f Makefile $*.tex.deps
	$(MAKE) $*.repeat

%.bbl: %.tex 
	$(rm)
	$(MAKE) $*.aux
	$(bibtex)

phony: ;

## Dependencies in the corresponding .mk
.PRECIOUS: %.tex.deps %.TEX.deps
%.tex.deps %.TEX.deps:
	touch $@

## This one should make if at all possible, and effectively only depend on the primary .tex; add dependencies for that if necessary?
Ignore += *.force.pdf
%.force.pdf: %.aux
	$(CP) $*.pdf $@

######################################################################

## Loop over reruns

%.texfinal: phony
	@while ! $(MAKE) -q $*.repeat ; do $(MAKE) $*.repeat; done;

%.texfinal.pdf: %.texfinal
	$(CP) $*.pdf $@

######################################################################

## Development on bus (move to sandbox)
body.tex.mk: body.tex makestuff/texj.pl

######################################################################

.PRECIOUS: %.tex.mk
%.tex.mk: %.tex 
	perl -wf makestuff/texj.pl $< > $@

## This seems like a mess; why should it be here?
## Why not just use tex.mk
.PRECIOUS: %.texdeps.mk
%.texdeps.mk: %.tex.mk 
	-$(MAKE) -f $*.tex.mk -f Makefile $*.tex.files
	cat $^ > $@

######################################################################

texfiles = $(wildcard *.tex)
Ignore += $(texfiles:tex=pdf)
Ignore += $(texfiles:tex=out)

## These direct exclusions can be replaced by fancier rules above if necessary
Ignore += *.biblog *.log *.aux .*.aux *.blg *.bbl *.bcf *.repeat *.texfinal
Ignore += *.nav *.snm *.toc
Ignore += *.run.xml
Ignore += *.tex.* *.TEX.* *.texdeps.mk
Ignore += *.aux.pdf *.aux.out *.texfinal.pdf

iclean:
	$(RM) *.deps.pdf *.subdeps *.deps.out

jclean:
	$(RM) *.biblog *.log *.aux .*.aux *.blg *.bbl *.bcf *.repeat *.complete
