include $(ms)/repos.def

repodirs = $(dushoff_github) $(ICI3D) $(Bio3SS) $(theobio_group)
repofiles = $(repodirs:%=%/Makefile)

$(dushoff_github):
	git submodule add git@github.com:dushoff/$@.git || mkdir $@

$(ICI3D):
	git submodule add git@github.com:ICI3D/$@.git || mkdir $@

$(Bio3SS):
	git submodule add git@github.com:Bio3SS/$@.git || mkdir $@

$(theobio_group):
	git submodule add git@github.com:mac-theobio/$@.git || mkdir $@

# Worried about infinite loops; will touch command help with time stamp?
# Do I need a sleep?
$(repofiles): %/Makefile: %
	git submodule init $<
	git submodule update $<
	touch $@

## To make things in these directories;
#### make the directory
#### go there and make and touch
maketouch = cd $$(dir $$@) && $$(MAKE) $$* && touch $$*
define dirmake
$(1)/%.mk: ;
$(1)/%: $(1)/Makefile ;
endef

$(foreach dir,$(repodirs),$(eval $(call dirmake,$(dir))))
