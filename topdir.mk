
### A bit repetitive with screendir.mk ☹

######################################################################

## Session and sync

screen_session:
	$(MAKE) Makefile $(screendirs:%=%.subscreen)

######################################################################

## Completion file

dirnames.mk: Makefile
	echo $(screendirs:%=%.subscreen) : > $@

-include dirnames.mk

######################################################################
