## Current situation is a mess. 
## Right now we can't include any tex files, because latexdeps will create direct dependencies that we don't know how to fill
## Need to decide what to do about inclusions from other directories before we address this. I'm thinking now to simply change latexdeps to get the right (indirect) dependency, but _only_ when no path is given.

latex = pdflatex -interaction=nonstopmode
bibtex = bibtex

include makestuff/perl.def
include $(wildcard .deps/*.d)

define ltx
	-/bin/cp -f $*.aux .$*.aux
	$(latex) $*; sleep 1
	diff .$*.aux $*.aux > /dev/null || touch $*.aux
endef

### Making the dependency files. We always want to include them, but don't want make to chain and try to make them.

### Make ./%.deps in the current directory, to be examined when we need it, and deleted otherwise. Hopefully, make can delete it automatically unless we ask for it explicitly

%.tex.deps: %.tex makestuff/latexdeps.pl
	$(PUSH)
	$(MAKE) .deps
	$(CP) $@ .deps/$<.d

.deps:
	mkdir $@

%.tex: .deps .deps/$@.d
	$(MAKE) $@.deps

.PRECIOUS: %.aux
%.aux: %.tex .deps
	$(MAKE) $<.deps
	touch $@
	$(ltx)

%.pdf: %.tex
	touch $<
	$(MAKE) $*.tex
	$(MAKE) $*.aux
#	diff .$< $< > /dev/null || $(MAKE) $*.ltx

%.bbl: %.tex 
	$(ltx)
	/bin/rm -f $@
	$(bibtex) $*

reset_deps:
	$(RMR) .deps/*.d *.deps

tclean:
	$(RM) *.aux *.bbl
