### Hooks for the editor to set the default target
current: target
include target.mk

##################################################################

# makestuff

ms = makestuff
Makefile: $(ms)

$(ms): dir = ~/hybrid/
$(ms): 
	ls $(dir)/$@ > /dev/null && /bin/ln -fs $(dir)/$@ .

-include local.mk
-include $(ms)/os.mk

# include $(ms)/perl.def

##################################################################

## Content
######################################################################

-include $(ms)/visual.mk
-include $(ms)/forms.mk

# -include $(ms)/wrapR.mk
# -include $(ms)/oldlatex.mk

