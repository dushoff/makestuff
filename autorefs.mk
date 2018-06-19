Makefile: bibdir
bibdir: 
	(touch $(Drop)/autorefs/testfile && $(LNF) $(Drop)/autorefs $@) || mkdir $@

export ms
export autorefs = $(ms)/autorefs

%.rmu: %.pmr
	perl -wf $(autorefs)/nodoi.pl $< > $@

%.bib %.int %.bibmk %.point: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

%.ref %.int %.refmk: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

%.md %.mdmk: %.rmu
	$(MAKE) -f $(autorefs)/Makefile $@

