
now:
	@echo $(now)

ifndef slowdir
slowdir = slow
endif

Ignore += $(slowdir)

ifndef cachedir
cachedir = git_cache
endif

## Add updated cache files to staging area
cachefiles = $(wildcard $(cachedir)/*)
add_cache: $(cachefiles:%=%.addup)

%.addup:
	! $(MAKE) -q $* || git add $*

## nocache means don't _rely_ on anything in the cache; cache still updated as appropriate
%.nocache:
	$(MAKE) nocache=TRUE $*

## forcecache means _just_ rely on the cache; don't look upstream
%.forcecache:
	$(MAKE) forcecache=TRUE $*

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
