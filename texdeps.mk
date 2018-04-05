
ifeq ($(latex),)
latex = pdflatex -interaction=nonstopmode
endif

ifeq ($(bibtex),)
bibtex = biber $* || bibtex $*
endif

%.pdf: %.tex .texdeps/%.out
	$(MAKE) .texdeps/$*.mk
	-$(MAKE) $*.deps
	$(MAKE) $*.ltx
	@!(grep "Fatal error occurred" $*.log)
	sleep 1 ### Make sure time stamps are distinct
	@(grep "Rerun to get" $*.log && touch $<) || :
	@(grep "Error:" $*.log && touch $<) || :
	@grep "Stop." .texdeps/$*.make.log || :
	@grep "failed" .texdeps/$*.make.log || :

%.bbl: %.ltx
	$(bibtex)

# 	$(MAKE) -q -f .texdeps/$*.mk -f Makefile .texdeps/$*.out || $(MAKE) -n
#	-$(MAKE) -f .texdeps/$*.mk -f Makefile .texdeps/$*.out

.texdeps/%.mk: %.tex 
	$(MAKE) .texdeps 
	perl -wf $(ms)/texdeps.pl $< > $@

## This rule makes the first copy of the .out
## Meant to be over-riden by rules in the corresponding .mk
.PRECIOUS: .texdeps/%.out
.texdeps/%.out: 
	$(MAKE) .texdeps 
	touch $@

.texdeps:
	$(mkdir)

%.ltx:
	-$(latex) $*

# Update dependencies for a .tex file
# A phony target
%.deps: .texdeps/%.mk 
	-$(MAKE) -dr -f $< -f Makefile .texdeps/$*.out | tee .texdeps/$*.make.log 2>&1

Ignore += *.log *.aux .*.aux *.blg *.bbl *.bcf *.run.xml .texdeps/

texfiles = $(wildcard *.tex)
Ignore += $(texfiles:tex=pdf) $(texfiles:tex=out)

### Doesn't quite fit here (or anywhere)

%_olddiff.tex: %.tex.*.oldfile %.tex $(ms)/latexdiff.pl
	$(PUSH)

