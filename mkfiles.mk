
Sources += $(wildcard mkfiles/*.make)
.PRECIOUS: mkfiles/%.make
mkfiles/%.make:
	cp makestuff/mkfiles.Makefile $@

%/Makefile: mkfiles/%.make
	cd $* && $(LN) ../mkfiles/$*.make Makefile

%.project:
	- git rm mkfiles/$*.make
	$(CPF) makestuff/project.Makefile $*/Makefile
