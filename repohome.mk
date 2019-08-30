-include makestuff/repohome.auto.mk

makestuff/repohome.auto.mk: makestuff/repohome.list makestuff/repohome.pl
	perl -wf $(filter %.pl, $^) $(filter-out %.pl, $^) > $@

%: rhdir/%
	$(MAKE) rhdir/$* || $(MAKE) rhdir/$<

rhdir:
	@echo "You need to make an rhdir to use repohome" && false

rhdir/%:
	git clone $(url) $@
	$(LN) $@ $*

rhdir_drop:
	$(MAKE) ~/Dropbox/rhdir
	$(LN) ~/Dropbox/rhdir rhdir

~/Dropbox/rhdir:
	$(mkdir)

