
# make files

Sources = Makefile .gitignore README.md

######################################################################

ms = ../makestuff

-include $(ms)/local.mk
-include local.mk
-include $(ms)/git.mk

-include $(ms)/visual.mk

# -include $(ms)/RR.mk
# -include oldlatex.mk
