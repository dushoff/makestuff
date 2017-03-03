include $(ms)/perl.def

# You can change these variables _after_ including 
latex = pdflatex -interaction=nonstopmode
bibtex = biber

.PRECIOUS: %.aux
%.aux: /proc/uptime %.tex
	- $(MAKE) -f $(ms)/deps.mk -f Makefile $*.reqs $@

%.pdf: %.aux
	- $(MAKE) -f $(ms)/deps.mk -f Makefile $*.reqs
	touch $<
	$(call hcopy, $<)
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

texclean:
	$(RM) *.aux *.bbl *.bcf *.blg *.reqs *.deps
