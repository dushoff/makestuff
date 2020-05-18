
######################################################################

## Session and sync

screen_session:
	$(MAKE) Makefile $(screendirs:%=%.vscreen)

alldirs += $(screendirs)
Ignore += $(screendirs) $(otherdirs)

######################################################################

## Completion file

dirnames.mk: Makefile
	echo $(screendirs:%=%.vscreen) : > $@

-include dirnames.mk

######################################################################
