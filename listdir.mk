ifdef git_dir
$(error load listdir.mk before git.mk)
endif

ifndef PUSH
-include makestuff/perl.def
endif

######################################################################

## Screen list and rules

## In a new clone, we want to make screens.list first
listscreens = perl -wf makestuff/arclist.pl screens.arc > screens.list
screens.list:
	$(listscreens)

## Now we should be able to make screens.mk
Ignore += screens.mk screens.list .screens.list
screens.mk: screens.list
	perl -wf makestuff/lmk.pl $< > $@ || ($(RM) $@ && false)

## screens.arc is made from screens.list and saved
## Should probably be read-only
Sources += screens.arc
screens.arc: screens.list makestuff/listarc.pl
	$(MAKE) screens.mk
	$(PUSH)

## Make sure to make arc from list before making list from arc!
screens.update: screens.arc
	- $(call hide, screens.list)
	 $(listscreens)

screens_resource:
	perl -i -wf makestuff/screensource.pl screens.list
	perl -i -wf makestuff/oldsource.pl screens.list

-include screens.mk

######################################################################

## Syncing

alldirs += $(listdirs)
alldirs += makestuff
Ignore += $(listdirs) $(resting)

## making
$(ruledirs):
	$(MV) $(old) $@ || git clone $(url) $@
