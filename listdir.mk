ifdef git_dir
$(error load listdir.mk before git.mk)
endif

ifndef PUSH
-include makestuff/perl.def
endif

## Screen list and rules

Sources += screens.arc
Ignore += screens.mk screens.list .screens.list
screens.mk: screens.list
	perl -wf makestuff/lmk.pl $< > $@ || ($(RM) $@ && false)

screens.arc: screens.list makestuff/listarc.pl
	$(MAKE) screens.mk
	$(PUSH)
screens.update: screens.arc
	- $(call hide, screens.list)
	 perl -wf makestuff/arclist.pl screens.arc > screens.list
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
