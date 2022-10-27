
## Make a Makefile that's hidden from the repo with make <dir>/mkfile
## Add it to repo with make <dir>/repofile
## Don't forget to un-ignore! [Does add help below?]

## Curate linked Makefiles in a mkfiles directory in the parent
Sources += $(wildcard mkfiles/*.make)
.PRECIOUS: mkfiles/%.make
mkfiles/%.make:
	$(MAKE) mkfiles
	cp makestuff/mkfiles.Makefile $@

Sources += $(wildcard mkfiles/*.wrap)
.PRECIOUS: mkfiles/%.wrap
mkfiles/%.wrap:
	$(MAKE) mkfiles
	cp makestuff/mkfiles.wrap $@

mkfiles:
	$(mkdir)

mklink = cd $* && $(LN) ../mkfiles/$*.make Makefile
%.mkfile: 
	$(MAKE) $*
	$(MAKE) mkfiles/$*.make
	$(mklink)

## If somebody wants a make file and the linked one already exists, then use it
%/Makefile:
	$(MAKE) $*
	$(mklink)

## Wrapper only (for projects with Makefile, add a secret makefile)
wraplink = cd $* && $(LN) ../mkfiles/$*.wrap makefile
%/makefile:
	$(MAKE) $*
	$(MAKE) mkfiles/$*.wrap
	$(wraplink)

## Make Linked Makefile into a repository file
## Keep any changes made before that (remember to change Source and so one)
%/repofile:
	$(RM) $*/Makefile
	$(CPF) mkfiles/$*.make $*/Makefile
	git rm mkfiles/$*.make
	cd $* && git add Makefile

## Make a default Makefile instead (don't use links at all)
%.defmake: 
	$(MAKE) $*
	$(CP) makestuff/project.Makefile $*/Makefile
