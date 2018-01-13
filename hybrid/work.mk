
######################################################################

## Hooks

current: target
target = Makefile
-include target.mk

###################################################################

# stuff

Sources += Makefile .ignore README.md substuff.mk LICENSE.md

## Change Drop with untracked local.mk (called automatically from substuff.mk)
Drop = ~/Dropbox

-include substuff.mk
# -include $(ms)/perl.def
# -include $(ms)/newtalk.def
# -include $(ms)/repos.def

######################################################################

## Directories

# clonedirs += clone
clone:
	git clone https://github.com/Bio3SS/$@.git

# mdirs += test
test:
	git submodule add -b master https://github.com/Bio3SS/$@

# pushdir = web/materials

## repodirs have auto-making rules from modules.mk
## mdirs are used by recursive git rules
repodirs += $(specdirs)
mdirs = $(specdirs)

######################################################################

## Content

######################################################################

-include $(ms)/visual.mk
-include $(ms)/git.mk

# -include $(ms)/texdeps.mk
# -include $(ms)/newtalk.mk

# -include $(ms)/modules.mk

# -include $(ms)/webpix.mk
# -include $(ms)/wrapR.mk

