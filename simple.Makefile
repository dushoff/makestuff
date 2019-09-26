## Target (for playing fancy vim games with the default target)
current: target
-include target.mk

### Makestuff rules you may want. The os is basic and shouldn't hurt
### Others can be commented in and out
## -include makestuff/perl.def

######################################################################

# Main content here

## You may want to CP content.mk here for convenience (if it exists),
## then delete this line (although it won't hurt you much)
-include content.mk

######################################################################

### Makestuff rules
Sources += Makefile 
msrepo = https://github.com/dushoff

Ignore += makestuff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk
-include makestuff/git.mk
-include makestuff/visual.mk

