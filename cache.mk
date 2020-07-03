
%.Rout.cache:
	$(MAKE) cache || (echo NOTICE from cache.mk: You need to make a cache/ && false)
	$(MAKE) $*.Rout
	$(CP) $*.Rout cache
	$(CP) .$*.RData cache

%.cache: 
	$(MAKE) cache || (echo NOTICE from cache.mk: You need to make a cache/ && false)
	$(MAKE) $*
	$(CP) $* cache

## Fanciness
## Not even vaguely implemented j

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
