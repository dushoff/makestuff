
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

%.newwork: % %.workfiles
	$(firstpush)

%.workfiles: %
	! ls $*/Makefile || (echo newwork: Makefile exists; return 1)
	cp $(ms)/work.mk $*/Makefile
	cp $(ms)/hybrid/makestuff.mk $(ms)/target.mk $*

%/Makefile %/link.mk %/target.mk %/sub.mk:
	$(CP) $(ms)/$(notdir $@) $*/

## Not tested; want to make a working repo soon!
## container
%.newcontainer: %.containerfiles %.first

%.containerfiles: %
	! ls $*/Makefile || (echo new files: Makefile exists; return 1)
	cp $(ms)/hybrid/container.mk $*/Makefile
	cp $(ms)/hybrid/upstuff.mk $(ms)/target.mk $*

## working
%.newwork: %.workfiles %.first ;

%.workfiles: %
	! ls $*/Makefile || (echo new files: Makefile exists; return 1)
	echo "# $*" > $*/Makefile
	cat $(ms)/hybrid/work.mk >> $*/Makefile
	cp $(ms)/hybrid/substuff.mk $(ms)/target.mk $*

%.first:
	cd $* && $(MAKE) makestuff && $(MAKE) commit.default && $(MAKE) push

## Old

%.newhybrid: % %.hybridfiles
	cd $* && make makestuff

%.hybridfiles: %
	! ls $*/Makefile || (echo newhybrid: Makefile exists; return 1)
	cp $(ms)/makefile.mk $*/Makefile
	cp $(ms)/hybrid/makestuff.mk $(ms)/target.mk $*

