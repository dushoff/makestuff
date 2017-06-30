
now:
	@echo $(now)

ifndef slowdir
slowdir = slow
endif

ifndef cachedir
cachedir = git_cache
endif

## Add updated cache files to staging area
# Recipe does not work if nocache is called recursively; make doesn't pass the -q along!
cachefiles = $(wildcard $(cachedir)/*)
add_cache: $(cachefiles:%=%.addup)

%.addup:
	! $(MAKE) -q nocache=TRUE $* || git add $*

%.nocache:
	$(MAKE) nocache=TRUE $*

$(slowdir)/%:
	$(MAKE) $(slowdir)
	$(MAKE) $(cachedir)
	$(MAKE) $(cachedir)/$*
	(ls $@ > /dev/null 2>&1) || $(LNF) $(realpath .)/$(cachedir)/$* $(slowdir)

$(slowdir) $(cachedir):
	$(mkdir)

ifdef nocache
$(foreach target,$(notdir $(wildcard $(cachedir)/*)),$(eval $(slowdir)/$(target): $(cachedir)/$(target)))
endif
