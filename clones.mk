
# Can we make a good rule so we can just name names?
# $(clonedirs):

## Not tested
%.newsub: % 
	cd $* && make makestuff
	cd $* && make newpush

## Not good design. Need different Makefile (or same name for util file)
%.newhybrid: % %/Makefile %/link.mk %/target.mk
	cp $(ms)/hybrid/*.* $*
	cd $* && make makestuff
	cd $* && make newpush

%/Makefile %/link.mk %/target.mk %/sub.mk:
	$(CP) $(ms)/$(notdir $@) $*/
