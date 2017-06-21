
##################################################################

## Image drop

web_drop/%: missing.txt.pdf
	$(MAKE) web_drop
	cd Lecture_images && $(MAKE) files/$* || 

web_drop: Lecture_images
	$(MAKE) Lecture_images/Makefile
	$(LNF) $</files $@

Sources += personal.txt
my_images/%: my_images personal.txt.pdf
	(cd $< && $(MAKE) $*) || convert $(word 2, $^) $@

my_images: 
	$(LN) $(Drop)/my_images . || $(mkdir)

