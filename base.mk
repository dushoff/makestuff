## This is base.mk; use to do simple stuff if your Makefile is broken

current: target
-include target.mk
Ignore = target.mk

-include makestuff/os.mk

-include makestuff/git.mk
-include makestuff/visual.mk
