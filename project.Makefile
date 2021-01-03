## This is …

current: target
-include target.mk

# -include makestuff/perl.def

vim_session:
	bash -cl "vmt"

######################################################################

### Makestuff

Sources += Makefile

## Sources += content.mk
## include content.mk

Ignore += makestuff
msrepo = https://github.com/dushoff

## Want to chain and make makestuff if it doesn't exist
## Compress this ¶ to choose default makestuff route
Makefile: makestuff/Makefile
makestuff/Makefile:
clonestuff:
	git clone $(msrepo)/makestuff
localstuff: 
	cd .. && $(MAKE) makestuff
	ln -s ../makestuff .
flexstuff:
	(cd .. && $(MAKE) makestuff && ln -s ../makestuff .) \
	|| git clone $(msrepo)/makestuff
checkstuff:
	ls makestuff/Makefile

-include makestuff/os.mk

## -include makestuff/makeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
