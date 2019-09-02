
$(dirdirs):
	$(mkdir)
	cp makestuff/direct.Makefile $@/Makefile
	cd $@ && $(MAKE) makestuff

## This could go into a small .mk with what else?
## Maybe an execute variable to make the two main sets of screens
## Actually this stays here, because screens is unique
## But we will do related stuff for the dirdirs

alldirs += makestuff $(dirdirs)
Ignore += $(knowndirs)
