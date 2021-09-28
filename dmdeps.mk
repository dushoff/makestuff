## This requires markdown-style file being mined for deps to be $< (first prereq)
define dmd_r
	perl -wf makestuff/dmdmk.pl $< > $@.dmdmk
	$(MAKE) -f $@.dmdmk -f Makefile dmdeps
	$(RM) $@.dmdmk
endef
