

# A phony target
%.deps: .texdeps/%.mk %.tex
	$(MAKE) -f $< -f Makefile .texdeps/$*.out | tee .texdeps/$*.make.log 2>&1

## Try harder (and try to stop in the right place)
## Fiddling with this 2020 Jun 13 (Sat)
%.alltex: 
	$(MAKE) $*.deps || $(MAKE) $*.ltx
	$(MAKE) $*.deps && $(MAKE) $*.pdf

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

