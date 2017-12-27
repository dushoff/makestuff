ifeq ($(latex),)
latex = pdflatex -interaction=nonstopmode
endif

ifeq ($(bibtex),)
bibtex = biber $* || bibtex $*
endif

%.pdf: %.tex .texdeps/%.out
	$(MAKE) $*.deps
	-$(MAKE) -f .texdeps/$*.mk -f Makefile .texdeps/$*.out
	$(MAKE) $*.ltx
	@!(grep "Fatal error occurred" $*.log)
	-@(grep "Rerun to get" $*.log && touch $<)
	-@(grep "Error:" $*.log && touch $<)

%.bbl: %.ltx
	$(bibtex)

.texdeps/%.mk: %.tex .texdeps 
	perl -wf $(ms)/texdeps.pl $< > $@

## This rule makes the first copy of the .out
## Meant to be over-riden by rules in the corresponding .mk
.PRECIOUS: .texdeps/%.out
.texdeps/%.out: .texdeps 
	touch $@

.texdeps:
	$(mkdir)

%.ltx:
	-$(latex) $*

# Update dependencies for a .tex file
# A phony target
# Why is the error suppression here instead of above?
%.deps: .texdeps/%.mk 
	-$(MAKE) -f $< -f Makefile .texdeps/$*.out

## Mystery ancient version
## -include $(wildcard *.deps)
