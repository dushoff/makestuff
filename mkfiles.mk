
Sources += $(wildcard mkfiles/*.make)
.PRECIOUS: mkfiles/%.make
mkfiles/%.make: mkfiles/
	cp makestuff/mkfiles.Makefile $@

mkfiles/:
	$(mkdir)

%/Makefile: 
	$(MAKE) mkfiles/$*.make
	cd $* && $(LN) ../mkfiles/$*.make Makefile

%.project:
	- git rm mkfiles/$*.make && $(RM) $*/Makefile
	$(CPF) makestuff/project.Makefile $*/Makefile
