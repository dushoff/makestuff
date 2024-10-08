## This file is for adding a default, repo-specific Dropbox
## The local subdirectory is called drop

## local.mk needs to point to your Dropbox parent directory
## `make null.lmk` if the folder is under ~/Dropbox/resources/<thisdirname>
## If you do this, you are not protected from having two ldrops in the same directory.
## Otherwise edit <yourname>.local and use `make <yourname.lmk>`

-include local.mk
drop ?= ~/Dropbox/resources/$(notdir $(CURDIR))

Ignore += drop
drop: dir=$(drop)
drop:
	@ ls local.mk || (echo "STOP: see makestuff/ldrop.mk" && false)
	$(alwayslinkdirname)

Sources += $(wildcard *.local)
null.lmk:
	touch local.mk
%.lmk:
	ln -fs $*.local local.mk

######################################################################

testsetup: updrop

updrop:
	$(LN) ../drop .
