## This file is for adding a default, repo-specific Dropbox
## resources is not the best name; revisit

## local.mk needs to point to your Dropbox
## `make null.lmk` if the folder is under ~/Dropbox/resources/<thisdirname>
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
