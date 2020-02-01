## Should auto stuff be here, or just in the staging directory?
-include makestuff/repohome.auto.mk

makestuff/repohome.auto.mk: makestuff/repohome.list makestuff/repohome.pl
	perl -wf $(filter %.pl, $^) $(filter-out %.pl, $^) > $@

## 2019 Aug 30 (Fri)
## This rule should be safe now, because it has only generated rules
## (with dependencies) for the next link
define rhsetup
$(MAKE) $(dir)
$(ddcopy)
cd $@ && $(MAKE) Makefile && $(MAKE) makestuff/Makefile && $(MAKE) makestuff.msync && $(MAKE) all.time
endef

## Not working because rhsetup uses ddcopy which depends on dir variable
## Patch 2020 Jan 16 (Thu)
## %: rhdir/%; $(rhsetup) || $(dircopy)

## Can't call make from rhdir because of loops
Ignore += rhdir
Makefile: rhdir
rhdir:
	$(LN) ~/Dropbox/$@ . || (echo "You need to make an rhdir to use repohome" && @echo "See example rules rhdir_drop and rhdir_local" && false)

rhmake = git clone $(url) $@

## 2019 Aug 30 (Fri) These rules might be fun to generalize
rhdir_drop:
	$(MAKE) ~/Dropbox/rhdir

rhdir_local:
	$(MD) rhdir

## This doesn't and shouldn't chain. People can decide for themselves
## whether and where to make an rhdir_drop
## In fact, why have it; it's just noise?
~/Dropbox/rhdir:
	$(mkdir)

