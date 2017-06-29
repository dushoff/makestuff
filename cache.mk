Archive += $(wildcard $(cachedir)/*)

ifndef slowdir
slowdir = slow
endif

ifndef cachedir
cachedir = git_cache
endif

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

