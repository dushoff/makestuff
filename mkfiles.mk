## USAGE
## Make a Makefile that's hidden from the repo
#### `make <dir>.mkfile`
## To add it to the repo later (back to a normal structure):
#### `make <dir>.repofile` #### Don't forget to un-ignore!

## make an exogenously tracked wrapper makefile:
## ONLY if there is alread a Makefile
#### `make dir/makefile`
## Consider using stealth instead (newish, not documented 2026 Jan 08 (Thu))

## Make a default Makefile from the start instead:
#### `make <dir>.defmake`

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

## Make this a real target 2026 Jan 08 (Thu)
Ignore += *.mkfile
mklink = ls mkfiles/$*.make && cd $* && $(LN) ../mkfiles/$*.make Makefile
%.mkfile: 
	$(MAKE) $*
	$(MAKE) mkfiles/$*.make
	$(mklink)
	touch $@

## If somebody wants a make file and the linked one already exists, then use it
%/Makefile:
	$(MAKE) $*
	@ ($(mklink)) || echo ERROR No mkfile found, did you mean to make one?

## Wrapper only (for projects with Makefile, add a secret makefile)
wraplink = cd $* && $(LN) ../mkfiles/$*.wrap makefile
%/makefile:
	$(MAKE) $*
	$(MAKE) mkfiles/$*.wrap
	$(wraplink)

## Make Linked Makefile into a repository file
## Keep any changes made before that
## Remember to change Ignore to Source and so one
## This is a dangerous rule! Is it, though?
%.repofile:
	$(RM) $*/Makefile
	$(CPF) mkfiles/$*.make $*/Makefile
	git rm mkfiles/$*.make
	cd $* && git add Makefile

## Make a default Makefile instead (don't use links at all)
%.defmake: 
	$(MAKE) $* || mkdir $*
	$(CP) makestuff/project.Makefile $*/Makefile

## Make a new directory that is ready for a Dushoff-style project
## Is this the best place for that? Maybe, since defmake is here already
%.newrepo:
	mkdir -p $*
	$(MAKE) $*.defmake
	$(MAKE) $*.vscreen
