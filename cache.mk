
now:
	@echo $(now)

ifndef slowdir
slowdir = slow
endif

ifndef cachedir
cachedir = git_cache
endif

## Automatically add already up-to-date cachefiles to repo

cachefiles = $(wildcard $(cachedir)/*)
commit.time: $(cachefiles:%=%.addup)

# This rule does not work if nocache is called recursively; make doesn't pass the -q along!
%.addup:
	($(MAKE) -q nocache=TRUE $* && git add $*) || ! $(MAKE) -q nocache=TRUE $*

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

