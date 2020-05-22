ifdef git_dir
$(error listdir.mk should go before git.mk)
endif

ifndef PUSH
-include makestuff/perl.def
endif

## Screen list and rules

Sources += screens.update screens.list 

Ignore += screens.mk
screens.mk: screens.list
	perl -wf makestuff/lmk.pl $< > $@ || cat /dev/null > $@

screens.update: screens.list
	perl -i -wf makestuff/io.pl screens.list
	perl -i -wf makestuff/screensource.pl screens.list
	touch $@
screens_old:
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
