
Sources = Makefile .gitignore README.md makestuff.mk LICENSE.md
-include target.mk

# -include $(ms)/perl.def

##################################################################

## Content

######################################################################

include makestuff.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk

# -include $(ms)/wrapR.mk
# -include $(ms)/texdeps.mk
