Ignore += slowtarget/
Sources += $(wildcard slow/*)

.PRECIOUS: slow/%

ifdef makeSlow
slow/%: slowtarget/% | slowtarget slow
	$(copy)
else
slow/%: | slowtarget slow;
	$(MAKE) slowtarget/$*
	$(CP) slowtarget/$* $@
endif

slowtarget slow:
	$(mkdir)

%.final:
	$(MAKE) makeSlow=defined $*

slowsync:
	rsync -r slow/ slowtarget
