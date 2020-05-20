ifdef git_dir
$(error listdir.mk should go before git.mk)
endif

ifndef PUSH
-include makestuff/perl.def
endif

## Screen list and rules

Sources += screens.list 

Ignore += screens.mk
screens.mk: screens.list
	perl -wf makestuff/lmk.pl $< > $@

screens_update:
	perl -i -wf makestuff/io.pl screens.list
	perl -i -wf makestuff/screensource.pl screens.list
screens_old:
	perl -i -wf makestuff/oldsource.pl screens.list

-include screens.mk

######################################################################

## Syncing

alldirs += $(screendirs)
alldirs += makestuff
Ignore += $(screendirs) $(otherdirs)

######################################################################

## clones
$(listdirs):
	$(MV) $(old) $@ || git clone $(url) $@
