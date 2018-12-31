
## Make things in the cache if necessary
%.buildcache:
	$(MAKE) buildcache=TRUE $*

## Seal the gap; make things without any protection from cache
%.rebuildcache:
	$(MAKE) rebuildcache=TRUE $*

## Make things in slow directory by linking to cache directory
## But don't tell them about the dependency most of the time
## Don't link if the file already exists; it creates confusion (at least in the editor)
ifdef forcecache
$(slowdir)/%:
	$(MAKE) $(slowdir)
	$(MAKE) $(cachedir)
	(ls $@ > /dev/null 2>&1) || $(LNF) $(realpath .)/$(cachedir)/$* $(slowdir)
else
$(slowdir)/%:
	$(MAKE) $(slowdir)
	$(MAKE) $(cachedir)
	$(MAKE) $(cachedir)/$*
	(ls $@ > /dev/null 2>&1) || $(LNF) $(realpath .)/$(cachedir)/$* $(slowdir)
endif

$(slowdir) $(cachedir):
	$(mkdir)

$(cachedir)/%.RData: %.RData
	$(copy)

## Rout stuff not tested!
$(slowdir)/%.Rout:
	$(MAKE) $(slowdir)
	$(MAKE) $(cachedir)
	$(MAKE) $(cachedir)/$*.Rout
	(ls $@ > /dev/null 2>&1) || $(LNF) $(realpath .)/$(cachedir)/$*.Rout $(call hiddenfile,  $(realpath .)/$(cachedir)/$*.RData) $(slowdir)

## Use nocache to turn on dependencies and un-break the link
ifdef nocache
$(foreach target,$(notdir $(wildcard $(cachedir)/*)),$(eval $(slowdir)/$(target): $(cachedir)/$(target)))
endif

ifdef nocache
$(foreach target,$(notdir $(wildcard $(cachedir)/*)),$(eval $(slowdir)/$(target): $(cachedir)/$(target)))
endif
