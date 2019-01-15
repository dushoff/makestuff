Makefile: cache
cachefiles =  $(CPR) cache/* cache/.?*.* .

## Default is to never make anything in the cache implicitly

## buildcache means make things in the cache if necessary
## Change the default by setting buildcache in your Makefile
%.buildcache:
	$(MAKE) buildcache=TRUE $*

## Seal the gap; make things without any protection from cache
%.rebuildcache:
	$(MAKE) rebuildcache=TRUE $*

ifdef rebuildcache
$(foreach target,$(notdir $(wildcard cache/*)),$(eval $(target): cache/$(target); - $(cachefiles)
else ifdef buildcache
%::
	- $(cachefiles)
else
all current target: ;
## This loops if there are any optional files (e.g., local.mk is requested not present)
## How about now? 2019 Jan 15 (Tue)
%:
	- $(cachefiles)
	ls $@
endif

clearcache:
	$(RM) cache/* cache/.?*.*
