## This file is for adding a default, repo-specific Dropbox
## resources is not the best name; revisit

## local.mk needs to point to your Dropbox
## `make null.lmk` if the folder is under ~/Dropbox/resources/<thisdirname>
## Otherwise edit <yourname>.local and use `make <yourname.lmk>`

Sources += $(wildcard *.local)
null.lmk:
	touch local.mk
%.lmk:
	ln -fs $*.local local.mk

-include local.mk
drop ?= ~/Dropbox/resources/$(notdir $(CURDIR))

Ignore += drop
drop: dir=$(drop)
drop:	| local.mk
	$(alwayslinkdirname)

local.mk:
	@ echo "STOP: Make local.mk manually (see makestuff/ldrop.mk)" && false

######################################################################

