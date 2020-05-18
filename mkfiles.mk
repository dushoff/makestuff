
Sources += $(wildcard mkfiles/*.make)
.PRECIOUS: mkfiles/%.make
mkfiles/%.make:
	cp mkfiles/mkfiles.make $@

%/Makefile: mkfiles/%.make
	cd $* && $(LN) ../$< Makefile

%/project:
	cp makestuff/project.Makefile $*/Makefile
