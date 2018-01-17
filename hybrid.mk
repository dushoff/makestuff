
# Can we make a good rule so we can just name names?
# $(clonedirs):

## Not tested
%.newsub: % 
	cd $* && make makestuff
	cd $* && make newpush

## HOT
%.newhybrid: % 
	! ls $*/Makefile || (echo newhybrid: Makefile exists; return 1)
	cp $(ms)/makefile.mk $*/Makefile
	cp $(ms)/hybrid/makestuff.mk $(ms)/target.mk $*
	cd $* && make makestuff
	cd $* && make newpush

%/Makefile %/link.mk %/target.mk %/sub.mk:
	$(CP) $(ms)/$(notdir $@) $*/
