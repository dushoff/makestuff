ifdef git_dir
$(error listdir.mk should go before git.mk)
endif

dirnames.mk: Makefile
	echo $(knowndirs:%=%.vscreen) : > $@

-include dirnames.mk

######################################################################

Sources += screens.list 
screen_number: screens.list makestuff/io.pl
	$(PIPUSH)

screens.mk: screens.list makestuff/lmk.pl
	$(MAKE) screen_number
	$(PUSH)

screen_session:
	$(MAKE) Makefile $(screendirs:%=%.vscreen)

## Syncing and alling
alldirs += $(screendirs)
Ignore += $(screendirs)

## clones
$(clonedirs):
	git clone $(url) $@
