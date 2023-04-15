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
