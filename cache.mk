cachefiles: 
	- $(CPR) cache/* cache/.?*.* .

## Make things in the cache if necessary
%.buildcache:
	$(MAKE) buildcache=TRUE $*

## Seal the gap; make things without any protection from cache
%.rebuildcache:
	$(MAKE) rebuildcache=TRUE $*

## Make things in slow directory by linking to cache directory
## But don't tell them about the dependency most of the time
## Don't link if the file already exists; it creates confusion (at least in the editor)
ifdef rebuildcache
$(foreach target,$(notdir $(wildcard cache/*)),$(eval $(target): cache/$(target); $(MAKE) cachefiles))
else ifdef buildcache
%:: 
	$(MAKE) cache/$*
	$(MAKE) cachefiles
else
all current target: ;
%::
	$(MAKE) cachefiles
	ls $@
endif

clearcache:
	$(RM) cache/* cache/.?*.*
