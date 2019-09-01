
## recipes to be included in screen_session
pvscreens = $(MAKE) $(projdirs:%=%.vscreen)
lvscreens = $(MAKE) $(linkdirs:%=%.vscreen)
plvscreens = $(pvscreens) && $(lvscreens)

## Hooks for bash so we can autocomplete from dirdir and get what we want

knowndirs += $(projdirs) $(linkdirs) $(rprojdirs) $(rlinkdirs)
dirnames.mk: Makefile
	echo $(knowndirs:%=%.vscreen) : > $@

-include dirnames.mk

## Syncing and alling
alldirs += $(projdirs)
Ignore += $(knowndirs)
