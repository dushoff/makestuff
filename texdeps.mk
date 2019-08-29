ifeq ($(latex),)
latex = pdflatex -interaction=nonstopmode
endif

ifeq ($(bibtex),)
bibtex = biber $* || bibtex $*
endif

%.alltex: %.deps %.pdf ;

%.pdf: %.tex .texdeps/%.out
	$(MAKE) .texdeps/$*.mk
	-$(MAKE) $*.deps ## Try the dependencies, but continue regardless
	$(MAKE) $*.ltx ## Always succeeds, but doesn't always make pdf
	sleep 1 ### Sleeping before checking Rerun
	$(MAKE) $*.texcheck ## Crash here if pdf has fatal error
	$(MAKE) $*.logreport ## Never crash here

## Working on better reporting 2018 Nov 29 (Thu)
## Are we geting everything we need from make log?
%.texcheck: 
	@!(grep "Fatal error occurred" $*.log)
	@(grep "Rerun to get" $*.log && touch $*.tex) || :

%.logreport: 
	@(grep "Error:" $*.log && touch $*.tex) || :
	@grep "Stop." .texdeps/$*.make.log || :
	@grep "failed" .texdeps/$*.make.log || :

%.bbl: %.tex %.ltx
	($(bibtex)) || ($(RM) $@ && false)

# 	$(MAKE) -q -f .texdeps/$*.mk -f Makefile .texdeps/$*.out || $(MAKE) -n
#	-$(MAKE) -f .texdeps/$*.mk -f Makefile .texdeps/$*.out

.PRECIOUS: .texdeps/%.mk
.texdeps/%.mk: %.tex 
	$(MAKE) .texdeps 
	perl -wf makestuff/texdeps.pl $< > $@

## This rule makes the first copy of the .out
## Meant to be over-riden by rules in the corresponding .mk
.texdeps/%.out: 
	$(MAKE) .texdeps 
	touch $@

.texdeps:
	$(mkdir)

%.ltx:
	-$(latex) $*

# Update dependencies for a .tex file
# A phony target
%.deps: .texdeps/%.mk %.tex
	-$(MAKE) -f $< -f Makefile .texdeps/$*.out | tee .texdeps/$*.make.log 2>&1

Ignore += .texdeps/

texfiles = $(wildcard *.tex)
Ignore += $(texfiles:tex=pdf) $(texfiles:tex=out)

## These direct exclusions can be replaced by fancier rules above if necessary
Ignore += *.biblog *.log *.aux .*.aux *.blg *.bbl *.bcf 
Ignore += *.nav *.snm *.toc
Ignore += *.run.xml

### Doesn't quite fit here (or anywhere)

%_olddiff.tex: %.tex.*.oldfile %.tex makestuff/latexdiff.pl
	$(PUSH)

