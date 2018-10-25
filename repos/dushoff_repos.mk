include $(ms)/repos/dushoff_repos.def

justclone:
	git clone $(repo)$(user)/$(target).git

clone: $(clonecommand)
clonedirs: clonecommand=justclone

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
