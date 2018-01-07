
# Can we make a good rule so we can just name names?
# $(clonedirs):

## Not tested
%.newclone: % %/Makefile %/sub.mk %/target.mk
	cd $* && make makestuff
	cd $* && make newpush

## Not tested
%.newhybrid: % %/Makefile %/link.mk %/target.mk
	cd $* && make makestuff
	cd $* && make newpush

%/Makefile %/link.mk %/target.mk %/sub.mk:
	$(CP) $(ms)/$(notdir $@) $*/
