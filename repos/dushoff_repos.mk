include $(ms)/dushoff_repos.def

repodirs += $(dushoff_github)

$(dushoff_github):
	$(MAKE) target=$@ repo=$(github) user=dushoff clone
