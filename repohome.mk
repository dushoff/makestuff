-include makestuff/repohome.auto.mk

makestuff/repohome.auto.mk: makestuff/repohome.list makestuff/repohome.pl
	perl -wf $(filter %.pl, $^) $(filter-out %.pl, $^) > $@

## 2019 Aug 30 (Fri)
## This rule should be OK now, because it has only generated rules
## (with dependencies) for the next link
%: rhdir/%
	$(rcopy)

rhdir:
	@echo "You need to make an rhdir to use repohome"
	@echo "See example rules rhdir_drop and rhdir_local" && false

rhmake = $(MAKE) rhdir && git clone $(url) $@

## 2019 Aug 30 (Fri) These rules might be fun to generalize
rhdir_drop:
	$(MAKE) ~/Dropbox/rhdir
	$(LN) ~/Dropbox/rhdir rhdir

~/Dropbox/rhdir:
	$(mkdir)

rhdir_local:
	$(MD) rhdir
