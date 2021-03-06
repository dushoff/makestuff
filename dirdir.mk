## Maybe this whole thing should be redone to make spinning out easier?
## alling can fail if dirdir doesn't run _before_ git.mk
ifdef git_dir
$(error dirdir.mk does not work after git.mk)
endif
dirdir = TRUE

## alling should be different in a dirdir; we don't actually want to commit, we went the big dir to do it for us.
## This means we need to control git.mk from here!

## A projdir is a regular repo project, it should be alled
## rprojdir is something that was and might be a projdir; it's resting
## I need to figure out how to protect myself … I think linkdirs can be read only … but we if we need a live and dead copy of the same thing? And how does chmod work?

## rprojdirs are _alled_ but not screened
## linkdirs are screened but not alled (these are the ones that need more care)
## deepdirs are deep resting
## deepdirs should be locked, and sometimes linkdirs will be, too

## Start to deprecate rhdir: rhsetup needs to be called manually now 2020 Jan 29 (Wed)
## notebook: dir=rhdir/notebook
## $(projdirs) $(rprojdirs): ; $(rhsetup)

## Making screens automatically
## recipes to be included in screen_session
## Makefile to avoid disaster when one of the variables is blank
pvscreens = $(MAKE) Makefile $(projdirs:%=%.vscreen)
lvscreens = $(MAKE) Makefile $(linkdirs:%=%.vscreen)
plvscreens = $(pvscreens) && $(lvscreens)

## Hooks for bash so we can autocomplete from dirdir and get what we want

## Finding screens to make them manually
## Use deepdir to hide something
knowndirs += $(projdirs) $(linkdirs) $(rprojdirs)
dirnames.mk: Makefile
	echo $(knowndirs:%=%.vscreen) : > $@

-include dirnames.mk

## Syncing and alling
alldirs += makestuff $(projdirs) $(rprojdirs)
Ignore += $(knowndirs) $(deepdirs)

pmsync:
	$(MAKE) $(projdirs:%=%.mmsync)

######################################################################

## Directory locking.
## Resist the temptation to be recursive; we want this to work on old directories, too
## What does this mean?? 2019 Sep 03 (Tue). chmod is a recursive Godzilla

## QMEE.lockdir:
%.lockdir:
	chmod -R a-w $*

## QMEE.unlockdir:
%.unlockdir:
	chmod -R ug+rwX $*
