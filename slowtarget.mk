Ignore += slowtarget/

## We always want to track stuff in slow, but not necessarily in the same repo
## because of privacy concerns!
## Sources += $(wildcard slow/*)

.PRECIOUS: slow/%

# slow target is always made if necessary, but only depends on its source when makeSlow is on (.final environment)
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

testsetup: slowsync
