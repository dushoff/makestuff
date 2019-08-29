
## OMG. Lots of stuff here that shouldn't be used, but what's here that's valuable? hotmake/coldmake?

# include makestuff/repos.def
## Add organizations to list, and make a rule

## A lot of stuff here should be phased out, or moved
## submake.mk for hot/cold dirs??

## Does not work without repos.def (or some other repo definer)
repodirs += $(dushoff_github) $(ICI3D) $(Bio3SS) $(theobio_group) $(dushoff_bitbucket)

repofiles = $(repodirs:%=%/Makefile)

$(dushoff_github):
	git submodule add -b master https://github.com/dushoff/$@.git || mkdir $@

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

######################################################################

%/target.mk:
	-cp makestuff/target.mk $@

%/sub.mk:
	-cp makestuff/sub.mk $@

%/Makefile:
	echo "# $*" > $@
	cat makestuff/hooks.mk >> $@
	cat makestuff/makefile.mk >> $@
	cd $* && $(MAKE) Makefile

######################################################################

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
#### Pulled the mk: ; from hotmake (see coldmake). It was interfering with init
#### Looping with directory prereq, even though I'm using maketouch
#### Any solution?
#### This problem solved for now 2018 Jan 23 (Tue) by eliminating wrapR
maketouch = cd $(1) && $$(MAKE) $$* && touch $$*
define hotmake
$(1)/%: $(1) $(1)/Makefile 
	$(maketouch)
endef

define coldmake
$(1)/%.mk: ;
$(1)/%: $(1)/Makefile 
	$(maketouch)
endef

$(foreach dir,$(repodirs),$(eval $(call hotmake,$(dir))))

## Adding to call from elsewhere
$(foreach dir,$(hotdirs),$(eval $(call hotmake,$(dir))))
$(foreach dir,$(colddirs),$(eval $(call hotmake,$(dir))))

######################################################################

# How to make repos that haven't been initialized yet??
# Semi-tested now. Worked with interruptions on 1M/
# Need to avoid rabbit hole of sort-of kind-of thinking this is the submodule version; need to _push_ the new directory, _then_ make it a submodule
# The current .init rule _makes_ then _deletes_ the non-submodule version.
# There was insane confusion with giving it a different name.
%.init: 
	-$(RMR) $@ || !ls $@
	$(MAKE) -f makestuff/repos.mk $* || ls $* > /dev/null
	mv $* $@
	cd $@ && (git checkout -b master || git checkout master)
	$(MAKE) $@/target.mk $@/sub.mk $@/Makefile
	cd $@ && $(MAKE) makestuff && $(MAKE) newpush
	$(RMR) $@

%.sub: % %/Makefile ;

%.create: %.init %.sub ;

