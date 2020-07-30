
## A nogit Makefile for …

-include target.mk

vim_session: 
	bash -cl "vmt"

######################################################################

######################################################################

BASE = ~/screens
Makefile: makestuff/Makefile
	touch $@
makestuff/Makefile:
	ls $(BASE)/makestuff/Makefile && /bin/ln -s $(BASE)/makestuff 

-include makestuff/os.mk
-include makestuff/visual.mk
