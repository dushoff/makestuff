Sources += $(wildcard git_cache/*)

git_cache/%.Rout:
	$(MAKE) git_cache
	$(MAKE) $*.Rout
	$(CPF) $*.Rout .$*.RData git_cache

git_cache:
	$(mkdir)

%.nocache:
	$(MAKE) -f Makefile -f $(ms)/nocache.mk $*

