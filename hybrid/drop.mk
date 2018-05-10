## Hooks

current: target
target = Makefile
-include target.mk

###################################################################

# stuff

Sources += Makefile .gitignore
Ignore += .ignore

## You can change the location of makestuff in local.mk
msrepo = https://github.com/dushoff
ms = ./makestuff
Ignore += local.mk
-include local.mk
-include $(ms)/os.mk

Makefile: $(ms)

$(ms):
	cd $(dir $(ms)) && git clone $(msrepo)/$(notdir $(ms)).git
 
Ignore += $(ms)

# -include $(ms)/perl.def
# -include $(ms)/newtalk.def
# -include $(ms)/repos.def

######################################################################

## Content

######################################################################

-include $(ms)/visual.mk
-include $(ms)/git.mk

-include $(ms)/texdeps.mk
# -include $(ms)/newtalk.mk

# -include $(ms)/modules.mk

# -include $(ms)/webpix.mk
# -include $(ms)/wrapR.mk

