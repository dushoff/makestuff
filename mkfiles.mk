
Sources += $(wildcard mkfiles/*.make)
.PRECIOUS: mkfiles/%.make
mkfiles/%.make:
	cp makestuff/mkfiles.make $@

%/Makefile: mkfiles/%.make
	cd $* && $(LN) ../$< Makefile

%/project:
	cp makestuff/project.Makefile $*/Makefile
