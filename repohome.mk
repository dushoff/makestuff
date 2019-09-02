-include makestuff/repohome.auto.mk

makestuff/repohome.auto.mk: makestuff/repohome.list makestuff/repohome.pl
	perl -wf $(filter %.pl, $^) $(filter-out %.pl, $^) > $@

## 2019 Aug 30 (Fri)
## This rule should be OK now, because it has only generated rules
## (with dependencies) for the next link
## I have also thought about limiting this to projdirs and rprojdirs
%: rhdir/%
	$(rcopy)
	cd $* && $(MAKE) Makefile && $(MAKE) makestuff && $(MAKE) makestuff.msync && $(MAKE) all.time
## I am spinning here on how to build from scratch reliably with submodule makestuff 2019 Sep 02 (Mon)

Makefile: rhdir

rhdir:
	$(LN) ~/Dropbox/$@ . || (echo "You need to make an rhdir to use repohome" && @echo "See example rules rhdir_drop and rhdir_local" && false)

rhmake = git clone $(url) $@

## 2019 Aug 30 (Fri) These rules might be fun to generalize
rhdir_drop:
	$(MAKE) ~/Dropbox/rhdir

~/Dropbox/rhdir:
	$(mkdir)

rhdir_local:
	$(MD) rhdir

