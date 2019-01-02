## This seems like a mess now; maybe move most of the dushoff stuff to .def, and just a general repos.mk
include $(ms)/repos/dushoff_repos.def

bitbucket = https://dushoff@bitbucket.org
github = https://github.com

justclone:
	git clone $(repo)/$(user)/$(target).git

module:
	git submodule add -b master $(repo)$(user)/$(target).git

## Why does this not work? In particular, the mdirs override??
$(clonedirs):clonecommand=justclone
$(mdirs):clonecommand=module
## clonecommand = justclone

clone: $(clonecommand)

## Could add a $(MAKE) or a % dependency. But maybe better to watch how this rule is called.
mdmake = $(mdirs:%=%/Makefile)
$(mdmake): %/Makefile:
	git submodule update -i

######################################################################

repodirs += $(dushoff_github)

$(dushoff_github):
	$(MAKE) target=$@ repo=$(github) user=dushoff clone

######################################################################

$(dushoff_bitbucket):
	$(MAKE) target=$@ repo=$(bitbucket) user=dushoff clone

repodirs += $(dushoff_bitbucket)

######################################################################

$(Bio3SS):
	$(MAKE) target=$@ repo=$(github) user=Bio3SS clone

repodirs += $(Bio3SS)

######################################################################

$(mac-theobio):
	$(MAKE) target=$@ repo=$(github) user=mac-theobio clone

repodirs += $(mac-theobio)

######################################################################

$(Outbreak-analysis):
	$(MAKE) target=$@ repo=$(github) user=Outbreak-analysis clone

repodirs += $(Outbreak-analysis)

######################################################################
