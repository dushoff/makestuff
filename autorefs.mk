Makefile: bibdir
bibdir: 
	(touch $(Drop)/autorefs/testfile && $(LNF) $(Drop)/autorefs $@) || mkdir $@

## Awkward holdovers from wiki setup?
export ms
export autorefs = $(ms)/autorefs

pmr = $(wildcard *.pmr)
%.rmu: %.pmr
	perl -wf $(autorefs)/nodoi.pl $< > $@

pmrr = $(pmr:.pmr=.rmu)
Ignore += $(pmrr)

rmu = $(wildcard *.rmu) $(pmrr)
Ignore += $(rmu:.rmu=.bib) $(rmu:.rmu=.md) $(rmu:.rmu=.html)
%.bib %.int %.bibmk %.point: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

Ignore += *.int *.ref *.refmk
%.ref %.int %.refmk: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

Ignore += *.mdmk
%.md %.mdmk: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

