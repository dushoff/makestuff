include $(ms)/repos/dushoff_repos.def

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
