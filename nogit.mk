-include target.mk

ms = makestuff

Makefile: makestuff/Makefile
	touch $@
makestuff/Makefile:
	ls ~/screens/makestuff/Makefile && /bin/ln -s ~/screens/makestuff 

-include makestuff/os.mk
-include makestuff/visual.mk
