## This is the GENERIC gdrive mirror file

current: up.time
-include target.mk
Ignore = target.mk

# -include makestuff/perl.def

######################################################################

mirrors += cloud

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

Makefile: makestuff/01.stamp
makestuff/%.stamp: | makestuff
	- $(RM) makestuff/*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include local.mk

-include makestuff/os.mk

cloud = gdrive
-include makestuff/mirror.mk

-include makestuff/visual.mk
