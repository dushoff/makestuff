# This includes here do not need to be optional, because if make is here it has already found this directory. The call to _this_ file should be optional.
ifeq ($(shell uname), Linux)
include makestuff/linux.mk
else
include makestuff/apple.mk
endif

## Seems radical, but also just good
.SUFFIXES:

## Stuff that should work in any OS goes here, I guess; haven't been good about this
%.var:
	@echo $($*)

%.makevar:
	$(MAKE) $($*)
