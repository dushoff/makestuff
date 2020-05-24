ifdef git_dir
$(error listdir.mk should go before git.mk)
endif

ifndef PUSH
-include makestuff/perl.def
endif

## Screen list and rules

Sources += screens.arc

Ignore += screens.mk
screens.mk: screens.list
	perl -wf makestuff/lmk.pl $< > $@ || cat /dev/null > $@

screens.arc: screens.list makestuff/io.pl
	$(PUSH)
screens_resource:
	perl -i -wf makestuff/screensource.pl screens.list
	perl -i -wf makestuff/oldsource.pl screens.list

-include screens.mk

######################################################################

## Syncing

alldirs += $(screendirs)
alldirs += makestuff
Ignore += $(listdirs)

######################################################################

## clones
$(ruledirs):
	$(MV) $(old) $@ || git clone $(url) $@
