
## Cannibalizing into git.mk for now
## Should break that file up later!

# Can we make a good rule so we can just name names?
# $(clonedirs):
# Any reason for this whole file?

## Not tested
%.newsub: % 
	cd $* && make makestuff
	cd $* && make newpush

## HOT
define firstpush = 
cd $* && make makestuff
cd $* && make newpush
endef 

## newhybrid is a mess; it uses something like upstuff -- have to decide whether all makefiles should be the same, and just pass different sub files. Or what?
%.newhybrid: % %.hybridfiles
	$(firstpush)

%.hybridfiles: %
	! ls $*/Makefile || (echo newhybrid: Makefile exists; return 1)
	cp $(ms)/makefile.mk $*/Makefile
	cp $(ms)/hybrid/makestuff.mk $(ms)/target.mk $*

<<<<<<< HEAD
%/link.mk %/target.mk %/sub.mk:
=======
%.newwork: % %.workfiles
	$(firstpush)

%.workfiles: %
	! ls $*/Makefile || (echo newwork: Makefile exists; return 1)
	cp $(ms)/work.mk $*/Makefile
	cp $(ms)/hybrid/makestuff.mk $(ms)/target.mk $*

%/Makefile %/link.mk %/target.mk %/sub.mk:
>>>>>>> 8146f2eb50cdb4c0b5232591dbe607842deb7040
	$(CP) $(ms)/$(notdir $@) $*/
