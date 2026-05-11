## This file used to be something pre- ~/screens, repurposed now for ~/terminal
## Cribbing from makestuff/mkfiles.mk (and much more to think about)

## Make a default Makefile instead (don't use links at all)
%.defmake: 
	$(MAKE) $* || mkdir $*
	$(CP) makestuff/project.Makefile $*/Makefile

## Make a new directory that is ready for a Dushoff-style project
## Is this the best place for that? Maybe, since defmake is here already
%.newrepo:
	mkdir -p dirs/$*
	$(MAKE) dirs/$*.defmake
	$(MAKE) launch/$*.bashwindow.view
