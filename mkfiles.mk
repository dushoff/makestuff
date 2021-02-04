
## Make a Makefile that's hidden from the repo with make <dir>/mkfile
## Add it to repo with make <dir>/repofile
## Don't forget to un-ignore! [Does add help below?]

## This needs to be a MAKE call, because otherwise mkfiles with work get tromped
Sources += $(wildcard mkfiles/*.make)
.PRECIOUS: mkfiles/%.make
mkfiles/%.make: 
	$(MAKE) mkfiles
	cp makestuff/mkfiles.Makefile $@

mkfiles/:
	$(mkdir)

%.mkfile %/mkfile: 
	$(MAKE) mkfiles/$*.make
	cd $* && $(LN) ../mkfiles/$*.make Makefile

%/repofile:
	$(RM) $*/Makefile
	$(CPF) mkfiles/$*.make $*/Makefile
	git rm mkfiles/$*.make
	cd $* && git add Makefile
