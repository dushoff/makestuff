include $(ms)/perl.def

Sources += deps.mk

# You can change these variables after including this file, if you like
latex = pdflatex -interaction=nonstopmode
bibtex = biber

.PRECIOUS: %.aux
%.aux: /proc/uptime %.tex
	- $(MAKE) $*.reqs
	- $(MAKE) -f $(ms)/deps.mk $@

%.pdf: %.aux
	touch $<
	$(call hide, $<)
	$(latex) $*
	$(call difftouch, $<)

%.bbl: %.tex 
	/bin/rm -f $@
	$(bibtex) $*

%.reqs: %.deps
	-$(MAKE) -f $< -f Makefile $@

.PRECIOUS: %.deps
%.deps: %.tex $(ms)/flextex.pl
	$(PUSH)

tclean:
	$(RM) *.aux *.bbl *.bcf *.blg *.reqs *.deps
