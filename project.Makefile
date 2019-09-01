## This is XXX, a screens project directory
## makestuff/project.Makefile

current: target
-include target.mk

######################################################################

# Content

vim_session:
	bash -cl "vmt"

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
Makefile: makestuff/Makefile
	touch $@
makestuff/Makefile:
	ls ../makestuff/Makefile && /bin/ln -s ../makestuff 

-include makestuff/os.mk
-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk

