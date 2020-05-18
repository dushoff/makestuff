
######################################################################

## Session and sync

screen_session:
	$(MAKE) Makefile $(screendirs:%=%.vscreen)

######################################################################

## Completion file

dirnames.mk: Makefile
	echo $(screendirs:%=%.vscreen) : > $@

-include dirnames.mk

######################################################################
