define dmd
	$(MAKE) $*.dmdmk
	$(MAKE) -f $*.dmdmk -f Makefile $@
endef

%.dmdmk:
	perl -wf makestuff/dmdmk.pl $(filter-out %.pl, $^) > $@
