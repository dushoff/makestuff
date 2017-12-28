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
	sleep 1
	@!(grep "Fatal error occurred" $*.log)
	@(grep "Rerun to get" $*.log && touch $<) || touch $*.log
	@(grep "Error:" $*.log && touch $<) || touch $*.log
	@grep "Stop." .texdeps/$*.make.log || touch $*.log

%.bbl: %.ltx
	$(bibtex)

# 	$(MAKE) -q -f .texdeps/$*.mk -f Makefile .texdeps/$*.out || $(MAKE) -n
#	-$(MAKE) -f .texdeps/$*.mk -f Makefile .texdeps/$*.out

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
%.deps: .texdeps/%.mk 
	$(MAKE) -f $< -f Makefile .texdeps/$*.out >& .texdeps/$*.make.log

## Mystery ancient version
## -include $(wildcard *.deps)
