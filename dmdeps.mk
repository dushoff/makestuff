define dmd
	perl -wf makestuff/dmdmk.pl $< > $@.dmdmk
	$(MAKE) -f $@.dmdmk -f Makefile dmdeps
	$(RM) $@.dmdmk
endef
