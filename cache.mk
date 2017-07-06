
now:
	@echo $(now)

ifndef slowdir
slowdir = slow
endif

ifndef cachedir
cachedir = git_cache
endif

## Add updated cache files to staging area
cachefiles = $(wildcard $(cachedir)/*)
add_cache: $(cachefiles:%=%.addup)

%.addup:
	! $(MAKE) -q $* || git add $*

%.nocache:
	$(MAKE) nocache=TRUE $*

## Make things in slow directory by linking to cache directory
## But don't tell them about the dependency most of the time
## Don't link if the file already exists; it creates confusion (at least in the editor)
$(slowdir)/%:
	$(MAKE) $(slowdir)
	$(MAKE) $(cachedir)
	$(MAKE) $(cachedir)/$*
	(ls $@ > /dev/null 2>&1) || $(LNF) $(realpath .)/$(cachedir)/$* $(slowdir)

$(slowdir) $(cachedir):
	$(mkdir)

$(cachedir)/%.RData: %.RData
	$(copy)

## Use nocache to turn on dependencies and un-break the link
ifdef nocache
$(foreach target,$(notdir $(wildcard $(cachedir)/*)),$(eval $(slowdir)/$(target): $(cachedir)/$(target)))
endif
