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
	grep "Rerun to get" $*.log || touch $<

%.bbl: %.ltx
	$(bibtex)

.texdeps/%.mk: %.tex .texdeps 
	perl -wf $(ms)/texdeps.pl $< > $@

.texdeps/%: .texdeps 
	touch $@

.texdeps:
	$(mkdir)

%.ltx:
	-$(latex) $*

# Update dependencies for a .tex file
# A phony target
%.deps: .texdeps/%.mk 
	-$(MAKE) -f $< -f Makefile .texdeps/$*.out

## Mystery ancient version
## -include $(wildcard *.deps)
