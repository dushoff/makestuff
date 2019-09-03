-include makestuff/repohome.auto.mk

makestuff/repohome.auto.mk: makestuff/repohome.list makestuff/repohome.pl
	perl -wf $(filter %.pl, $^) $(filter-out %.pl, $^) > $@

## 2019 Aug 30 (Fri)
## This rule should be safe now, because it has only generated rules
## (with dependencies) for the next link
define rhsetup
$(rcopy)
cd $@ && $(MAKE) Makefile && $(MAKE) makestuff/Makefile && $(MAKE) makestuff.msync && $(MAKE) all.time
endef

%: rhdir/%
	$(rhsetup)

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

