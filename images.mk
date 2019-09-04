
## This looks course-specific, but which course? 2019 Sep 04 (Wed)

##################################################################

## Image drop

web_drop/%: makestuff/missing.pdf
	$(MAKE) web_drop
	(cd Lecture_images && $(MAKE) files/$*) || convert $^ $@

web_drop: Lecture_images
	$(MAKE) Lecture_images/Makefile
	$(LNF) $</files $@

my_images/%: my_images makestuff/personal.pdf
	(cd $< && $(MAKE) $*) || convert $(word 2, $^) $@

my_images: 
	(touch $(Drop)/my_images/test && $(LN) $(Drop)/my_images $@) || $(mkdir)

%.txt.ps: %.txt
	groff $< > $@

%.txt.pdf: %.txt.ps
	ps2pdf $< > $@
