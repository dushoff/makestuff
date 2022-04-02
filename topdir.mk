
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

-include target.mk
