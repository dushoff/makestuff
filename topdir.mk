
## Session and sync

screen_session:
	$(MAKE) Makefile $(screendirs:%=%.subscreen)

######################################################################

## Completion file

Ignore += dirnames.mk
dirnames.mk: screens.list
	echo $(screendirs:%=%.screen) : > $@
	echo $(screendirs:%=%.subscreen) : > $@

-include dirnames.mk

######################################################################

clonemake = $(clonedirs:%=%/Makefile)

now:
	@echo $(clonemake)

$(clonemake): %/Makefile:
	$(CP) makestuff/screendir.Makefile $@
	$(CP) makestuff/screens.list $*

