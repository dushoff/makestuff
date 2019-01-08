cachefiles: 
	$(MAKE) cache
	- $(CPR) cache/* cache/.?*.* .

## Default is to never make anything in the cache implicitly

## buildcache means make things in the cache if necessary
## Change the default by setting buildcache in your Makefile
%.buildcache:
	$(MAKE) buildcache=TRUE $*

## Seal the gap; make things without any protection from cache
%.rebuildcache:
	$(MAKE) rebuildcache=TRUE $*

ifdef rebuildcache
$(foreach target,$(notdir $(wildcard cache/*)),$(eval $(target): cache/$(target); $(MAKE) cachefiles))
else ifdef buildcache
%::
	$(MAKE) cache/$*
	$(MAKE) cachefiles
else
all current target: ;
%:
	$(MAKE) cachefiles
	ls $@
endif

clearcache:
	$(RM) cache/* cache/.?*.*
