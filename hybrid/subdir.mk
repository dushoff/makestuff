
######################################################################

## Hooks

current: target
target = Makefile
-include target.mk

###################################################################

# stuff

Sources += Makefile .ignore README.md upstuff.mk LICENSE.md

## Change Drop with untracked local.mk (called automatically from …stuff.mk)
Drop = ~/Dropbox

-include upstuff.mk
# -include $(ms)/perl.def
# -include $(ms)/newtalk.def
# -include $(ms)/repos.def

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

