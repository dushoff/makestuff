include $(ms)/repos.def

remotedirs = $(dushoff_github) $(ICI3D)
remotefiles = $(remotedirs:%=%/Makefile)

$(dushoff_github):
	git submodule add git@github.com:dushoff/$@.git

$(ICI3D):
	git submodule add git@github.com:ICI3D/$@.git

# Worried about infinite loops; will touch command help with time stamp?
# Do I need a sleep?
$(remotefiles): %/Makefile: %
	git submodule init $<
	git submodule update $<
	touch $@

