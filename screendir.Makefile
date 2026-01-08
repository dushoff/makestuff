# This is the screendir template Makefile

current: target
-include target.mk

-include makestuff/perl.def

######################################################################

vim_session: 
	bash -cl "vmt screens.list"

screen_session: screens.update
	$(MAKE) $(vscreens)

Ignore += screenlog.32

######################################################################

## Use to search for defunct directories
Ignore += time.tmp
time.tmp: phony
	ls -lt */Makefile > $@

phony: ;

### Makestuff

Sources += Makefile 

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile Downloads
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

### Includes

-include makestuff/os.mk

## -include makestuff/wrapR.mk

-include makestuff/listdir.mk
-include makestuff/screendir.mk
-include makestuff/mkfiles.mk

-include makestuff/git.mk
-include makestuff/visual.mk
