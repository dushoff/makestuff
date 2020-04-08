
## Make dirdirs
$(dirdirs):
	$(mkdir)
	cp makestuff/direct.Makefile $@/Makefile
	cd $@ && $(MAKE) makestuff

## Alling and tracking
## More of this should be here instead of in the screens Makefile 2019 Sep
alldirs += makestuff $(dirdirs) $(containers)
Ignore += $(knowndirs)

## repohome is deprecated and we don't know how to make most of our containers
## 2020 Apr 04 (Sat)

## $(containers): ; $(rhsetup)
## Get ready for repohome
%.rhd:
	cd $* && make rhdir_drop

rhdd:
	$(MAKE) $(dirdirs:%=%.rhd)

## Update recursively through dirdirs

%.pmsync:
	cd $* && $(MAKE) pmsync

dpmsync:
	$(MAKE) $(dirdirs:%=%.pmsync)
	$(MAKE) makestuff.msync

all.time: dirdirs.sync

dirdirs.sync: $(dirdirs:%=%.sync)
