
Sources += $(wildcard mkfiles/*.make)
.PRECIOUS: mkfiles/%.make
mkfiles/%.make:
	cp makestuff/mkfiles.make $@

%/Makefile: 
	cd $* && $(LN) ../mkfiles/$*.make Makefile

%.project:
	- git rm mkfiles/$*.make
	$(CPF) makestuff/project.Makefile $*/Makefile
