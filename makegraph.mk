## Graphing make dependencies with make2graph; see makegraph.md

## Dry-run debug trace
Ignore += *.nd.log
%.nd.log: Makefile
	make -nd $* > $@

## Graph through saved slow targets (like .final, but without the recursive make,
## which make2graph can't follow); shorter stem beats %.nd.log
%.final.nd.log: Makefile
	make -nd makeSlow=defined $* > $@

## Trace from a fresh clone (git.mk %.dd), so everything needs making
Ignore += *.dd.log
%.dd.log: %.dd.testsetup
	cd $*.dd && $(MAKE) $*.nd.log
	$(CP) $*.dd/$*.nd.log $@

Ignore += *.mg.dot
%.mg.dot: %.log
	make2graph $< > $@

## Filters work on the dot file, not the trace (dropping trace lines confuses make2graph)
## nom: drop makestuff machinery
%.nom.mg.dot: %.mg.dot makestuff/mgFilter.pl
	perl makestuff/mgFilter.pl nom $< > $@

## ns: drop slow/slowtarget directory nodes and merge slow/X into slowtarget/X
%.ns.mg.dot: %.mg.dot makestuff/mgFilter.pl
	perl makestuff/mgFilter.pl ns $< > $@

## mf: both of the above, in one pass
%.mf.mg.dot: %.mg.dot makestuff/mgFilter.pl
	perl makestuff/mgFilter.pl mf $< > $@

Ignore += *.mg.pdf
%.mg.pdf: %.mg.dot
	dot -Tpdf -o $@ $<
