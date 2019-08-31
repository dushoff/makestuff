
pvscreens = $(MAKE) $(projdirs:%=%.vscreen)
lvscreens = $(MAKE) $(linkdirs:%=%.vscreen)
plvscreens = $(pvscreens) && $(lvscreens)

alldirs += $(projdirs)
Ignore += $(projdirs) $(linkdirs) $(rprojdirs) $(rlinkdirs)
