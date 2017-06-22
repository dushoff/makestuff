
##################################################################

## Image drop

web_drop/%: $(ms)/missing.pdf
	$(MAKE) web_drop
	cd Lecture_images && $(MAKE) files/$* || convert $(word 2, $^) $@

web_drop: Lecture_images
	$(MAKE) Lecture_images/Makefile
	$(LNF) $</files $@

Sources += personal.txt
my_images/%: my_images $(ms)/personal.pdf
	(cd $< && $(MAKE) $*) || convert $(word 2, $^) $@

my_images: 
	$(LN) $(Drop)/my_images . || $(mkdir)

%.txt.ps: %.txt
	groff $< > $@

%.txt.pdf: %.txt.ps
	ps2pdf $< > $@
