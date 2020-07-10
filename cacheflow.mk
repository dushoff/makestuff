
ifndef pushdir
pushdir = cachestuff
endif

cachenotice =  NOTICE from cacheflow.mk:
nocachestuff =  $(cachenotice) You need to make a cachestuff/ directory
makecache = $(MAKE) cachestuff || (echo $(nocachestuff) && false)

%.Rout.cache:
	$(makecache)
	$(MAKE) $*.Rout
	$(CP) $*.Rout cachestuff
	$(CP) .$*.RData cachestuff

%.cache: 
	$(makecache)
	$(MAKE) $*
	$(CP) $* cachestuff

## This should be part of conditional fanciness eventually
cachestuff/%:
	$(makecache)
	@echo $(cachenotice) You need to make $*.cache manually && false

## Fanciness
## Not even vaguely implemented 2020 Jul 04 (Sat)
## This is just here because I'll want the syntake if I ever do it.

%.rebuildcache:
	$(MAKE) rebuildcache=TRUE $*

ifdef rebuildcache
$(foreach target,$(notdir $(wildcard cache/*)),$(eval $(target): cache/$(target); - $(cachefiles)))
else ifdef buildcache
## What the hell does this do?
%::
	- $(cachefiles)
else
endif
