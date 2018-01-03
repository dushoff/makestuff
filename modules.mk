# include $(ms)/repos.def

## Add organizations to list, and make a rule

## Does not work without repos.def (or some other repo definer)
repodirs += $(dushoff_github) $(ICI3D) $(Bio3SS) $(theobio_group) $(dushoff_bitbucket)

repofiles = $(repodirs:%=%/Makefile)

$(dushoff_github):
	git submodule add https://github.com/dushoff/$@.git || mkdir $@

$(dushoff_bitbucket):
	git submodule add https://bitbucket.org/dushoff/$@.git || mkdir $@

$(outbreak_github):
	git submodule add https://github.com/Outbreak-analysis/$@.git || mkdir $@

$(ici3d_github):
	git submodule add https://github.com/ICI3D/$@.git || mkdir $@

$(Bio3SS):
	git submodule add https://github.com/Bio3SS/$@.git || mkdir $@

$(Bio1M):
	git submodule add https://github.com/Bio1M/$@.git || mkdir $@

$(theobio_group):
	git submodule add https://github.com/mac-theobio/$@.git || mkdir $@

## Can't use $(MAKE) because loops. Can't use % because unwanted dependency.
## Just have things that ask for Makefile ask for directory first?
$(repofiles): %/Makefile:
	git submodule init $*
	git submodule update $*
	touch $@

%.subup:
	git submodule update $*

## To make things in these directories;
#### make the directory
#### go there and make and touch
#### This rule can either be hot or cold, depending on whether there is a $(1) dependency. Hot right now. Should make a way to control it.
maketouch = cd $(1) && $$(MAKE) $$* && touch $$*
define hotmake
$(1)/%.mk: ;
$(1)/%: $(1) $(1)/Makefile 
	$(maketouch)
endef

define coldmake
$(1)/%.mk: ;
$(1)/%: $(1)/Makefile 
	$(maketouch)
endef

$(foreach dir,$(repodirs),$(eval $(call hotmake,$(dir))))

######################################################################

# How to make repos that haven't been initialized yet??
# Semi-tested now. Worked with interruptions on 1M/
# Need to avoid rabbit hole of sort-of kind-of thinking this is the submodule version; need to _push_ the new directory, _then_ make it a submodule
# The current .init rule _makes_ then _deletes_ the non-submodule version.
# There was insane confusion with giving it a different name.
%.init: 
	- $(MAKE) -f $(ms)/repos.mk $*
	- cd $* && (git checkout -b master || git checkout master)
	$(MAKE) -f $(ms)/init.mk $*/target.mk $*/sub.mk $*/Makefile
	cd $* && $(MAKE) makestuff && $(MAKE) newpush
	$(RMR) $*

%.sub: % %/Makefile ;

%.create: %.init %.sub ;

%/target.mk:
	-cp $(ms)/target.mk $@

%/sub.mk:
	-cp $(ms)/sub.mk $@

%/Makefile:
	echo "# $*" > $@
	cat $(ms)/hooks.mk >> $@
	cat $(ms)/makefile.mk >> $@
	cd $* && $(MAKE) Makefile

