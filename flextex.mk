include $(ms)/perl.def

# You can change these variables after including this file, if you like
latex = pdflatex -interaction=nonstopmode
bibtex = biber

.PRECIOUS: %.aux
%.aux: /proc/uptime %.tex
	- $(MAKE) $*.reqs
	- $(MAKE) -f $(ms)/texdeps.mk -f Makefile $@

%.pdf: %.aux
	touch $<
	$(call hide, $<)
	$(latex) $*
	$(call difftouch, $<)

%.bbl: %.aux 
	/bin/rm -f $@
	$(bibtex) $*

%.reqs: %.deps
	-$(MAKE) -f $< -f Makefile $@

.PRECIOUS: %.deps
%.deps: %.tex $(ms)/flextex.pl
	$(PUSH)

tclean:
	$(RM) *.aux *.bbl *.bcf *.blg *.reqs *.deps
