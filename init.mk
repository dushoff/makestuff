msrepo = https://github.com/dushoff
projectrepos = 

gitroot = ./ 
export ms = $(gitroot)/makestuff

-include local.mk
-include $(gitroot)/local.mk
export ms = $(gitroot)/makestuff
-include $(ms)/os.mk

projectdirs = 

Makefile: $(ms) $(coursedirs)

$(ms):
	cd $(dir $(ms)) && git clone $(msrepo)/$(notdir $(ms)).git

$(projectdirs): local.mk
		$(MAKE) -f stuff.mk $(gitroot)
		cd $(gitroot) && git clone $(projectrepo)/$notdir $@).git
		cp local.mk $@

local.mk:
	echo gitroot = $(shell pwd) > $@

$(gitroot):
	mkdir $@
