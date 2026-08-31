
## Minimal

Sources += $(wildcard *.MK) Makefile

######################################################################

## Stealth-style header
## This is a personal makefile for XXX
## It is version-controlled as jd.MK and linked and used as local.mk

current: target
-include target.mk

vim_session:
	bash -ic "vi local.mk target.mk Makefile"

Sources += $(wildcard *.MK) Makefile
## Ignore += local.mk Should not be needed

######################################################################

## Add to bottom of Makefile (remember to make)

# Optional features (add your own MK file, or use someone else's)
-include local.mk
## jd.local: jd.MK
%.local: %.MK
	/bin/ln -fs $< local.mk

