
# Can we make a good rule so we can just name names?
# $(clonedirs):

## Not tested
%.newsub: % 
	cd $* && make makestuff
	cd $* && make newpush

## HOT
%.newhybrid: % 
	! ls $*.Makefile
	cp $(ms)/makefile.mk $*/Makefile
	cp $(ms)/hybrid/makestuff.mk $(ms)/target.mk $*
	cd $* && make makestuff
	cd $* && make newpush

%/Makefile %/link.mk %/target.mk %/sub.mk:
	$(CP) $(ms)/$(notdir $@) $*/
