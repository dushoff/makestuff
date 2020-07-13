
%.cache: 
	$(MAKE) cache || (cache.mk: You need to make a cache && false)
	$(MAKE) $*
	$(CP) $* cache
