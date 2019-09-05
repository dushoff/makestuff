# This includes here do not need to be optional, because if make is here it has already found this directory. The call to _this_ file should be optional.
ifeq ($(shell uname), Linux)
include makestuff/linux.mk
else
include makestuff/unix.mk
endif

## This doesn't _seem_ to belong here
%.var:
	@echo $($*)

%.makevar:
	$(MAKE) $($*)
