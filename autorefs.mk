Makefile: bibdir
Ignore += bibdir
bibdir: 
	@echo Checking for bibdir or Drop link
	(touch $(Drop)/autorefs/testfile && $(LNF) $(Drop)/autorefs $@) \
	|| mkdir $@

## Awkward holdovers from wiki setup?
export ms
export autorefs = makestuff/autorefs

## rmu is run through nodoi and everything else through rmu
## Does this mean we can't doi?
## Apparently so 2020 Feb 17 (Mon)
pmr = $(wildcard *.pmr)
%.rmu: %.pmr
	perl -wf $(autorefs)/nodoi.pl $< > $@

pmrr = $(pmr:.pmr=.rmu)
Ignore += $(pmrr)

rmu = $(wildcard *.rmu) $(pmrr)
Ignore += $(rmu:.rmu=.bib) $(rmu:.rmu=.md) $(rmu:.rmu=.html)
Ignore += *.bibmk *.point
%.bib %.int %.bibmk %.point: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

Ignore += *.int *.ref *.refmk
%.ref %.int %.refmk: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

Ignore += *.mdmk
%.md %.mdmk: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

## Corrections (via autorefs/Makefile)
Sources += $(wildcard *.corr)
%.corr:
	$(MAKE) -f $(autorefs)/Makefile $@
