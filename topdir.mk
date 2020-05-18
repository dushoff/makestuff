
### A bit repetitive with screendir.mk ☹

######################################################################

## Session and sync

screen_session:
	$(MAKE) Makefile $(screendirs:%=%.subscreen)

######################################################################

## Completion file

Ignore += dirnames.mk
dirnames.mk: Makefile
	echo $(screendirs:%=%.subscreen) : > $@

-include dirnames.mk

######################################################################

clonemake = $(clonedirs:%=%/Makefile)

now:
	@echo $(clonemake)

$(clonemake): %/Makefile:
	$(CP) makestuff/screendir.Makefile $@
	$(CP) makestuff/screens.list $*

