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
	perl -i -wf makestuff/io.pl screens.list
	perl -wf makestuff/lmk.pl $< > $@

-include screens.mk

######################################################################

## Session and sync

screen_session:
	$(MAKE) Makefile $(screendirs:%=%.vscreen)

top_session:
	$(MAKE) Makefile $(screendirs:%=%.subscreen)

alldirs += $(screendirs)
Ignore += $(screendirs)

######################################################################

## Completion file

dirnames.mk: Makefile
	echo $(screendirs:%=%.vscreen) : > $@

-include dirnames.mk

######################################################################

## clones
$(clonedirs):
	git clone $(url) $@
