## This is XXX, a screens project directory with a makestuff _submodule_
## makestuff/makemod.Makefile

current: target
-include target.mk

# -include makestuff/perl.def

######################################################################

# Content

vim_session:
	bash -cl "vmt"

######################################################################

## This ¶ can be deleted once makestuff is set up
msrepo = https://github.com/dushoff
makestuff/Makefile: makestuff
makestuff:
	git submodule add -b master $(msrepo)/makestuff

######################################################################

### Content

######################################################################

### Makestuff

Sources += Makefile makestuff

ms = makestuff
Makefile: makestuff/Makefile

makestuff/%.mk: makestuff/Makefile ;
makestuff/Makefile:
	git submodule update -i

-include makestuff/os.mk
-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
