include $(ms)/repos.def

repodirs = $(dushoff_github) $(ICI3D)
repofiles = $(repodirs:%=%/Makefile)

$(dushoff_github):
	git submodule add git@github.com:dushoff/$@.git || mkdir $@

$(ICI3D):
	git submodule add git@github.com:ICI3D/$@.git || mkdir $@

# Worried about infinite loops; will touch command help with time stamp?
# Do I need a sleep?
$(repofiles): %/Makefile: %
	git submodule init $<
	git submodule update $<
	touch $@

