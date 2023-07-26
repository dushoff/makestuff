
ifdef notimecache
timecache/%: % | timecache;
	$(copy)
else
timecache/%: | timecache;
	$(MAKE) $*
	$(CP) $* $@
endif

%.final:
	$(MAKE) notimecache=defined $*

timecache:
	$(mkdir)
