Ignore += slowtarget/

## Put this in your Makefile maybe
## Sources += $(wildcard slow/*)
## We always want to track stuff in slow, but not necessarily in the same repo
## because of privacy concerns!

## 2025 Dec 11 (Thu) This did not seem to work for my giant phenHet sim
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

%.finalview: %.final
	$(MAKE) $*.pdf.go || $(MAKE) $<.go

slowsync:
	rsync -r slow/ slowtarget

testsetup: slowsync
