ifdef git_dir
$(error listdir.mk should go before git.mk)
endif

## Screen list and rules

Sources += screens.list 
screen_number: screens.list makestuff/io.pl
	$(PIPUSH)

Ignore += screens.mk
screens.mk: screens.list makestuff/lmk.pl
	$(MAKE) screen_number
	$(PUSH)

-include screens.mk

######################################################################

## Session and sync

screen_session:
	$(MAKE) Makefile $(screendirs:%=%.vscreen)

alldirs += $(screendirs)
Ignore += $(screendirs)

######################################################################

## Completion file

dirnames.mk: Makefile
	echo $(knowndirs:%=%.vscreen) : > $@

-include dirnames.mk

######################################################################

## clones
$(clonedirs):
	git clone $(url) $@
