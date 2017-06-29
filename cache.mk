Sources += $(wildcard $(cachedir)/*)

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
	ls $@ || $(LNF) $(realpath .)/$(cachedir)/$* $(slowdir)

$(slowdir) $(cachedir):
	$(mkdir)

ifdef nocache
$(foreach target,$(notdir $(wildcard $(cachedir)/*)),$(eval $(slowdir)/$(target): $(cachedir)/$(target)))
endif

