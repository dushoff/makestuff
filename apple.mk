-include makestuff/unix.mk

%.go:
	$(MAKE) $*
	open $*
