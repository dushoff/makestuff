
# Can we make a good rule so we can just name names?
# $(clonedirs):
# Any reason for this whole file?

## Not tested
%.newsub: % 
	cd $* && make makestuff
	cd $* && make newpush

## HOT
%.newhybrid: % %.hybridfiles
	cd $* && make makestuff
	cd $* && make newpush

%.hybridfiles: %
	! ls $*/Makefile || (echo newhybrid: Makefile exists; return 1)
	cp $(ms)/makefile.mk $*/Makefile
	cp $(ms)/hybrid/makestuff.mk $(ms)/target.mk $*

%/Makefile %/link.mk %/target.mk %/sub.mk:
	$(CP) $(ms)/$(notdir $@) $*/
