## Graphing (weird stuff, and acting weird for now)

Ignore += *.nd.log
%.nd.log: Makefile
	make -nd $* > $@

## Graph through saved slow targets (like .final, but without the recursive make,
## which make2graph can't follow); shorter stem beats %.nd.log
%.final.nd.log: Makefile
	make -nd makeSlow=defined $* > $@

Ignore += *.nom.log
%.nom.log: %.nd.log
	cat $< | grep -v makestuff | grep -v "\.mk" > $@

%.fast.log: %.log
	cat $< | grep -v slowtarget > $@

Ignore += *.mg.dot
%.mg.dot: %.log
	make2graph $< > $@

Ignore += *.mg.pdf
%.mg.pdf: %.mg.dot
	dot -Tpdf -o $@ $<

## Does not chain through wildcard; also, the graph has unexplained orphanism
%.dd.log: %.dd.testsetup $(wildcard %.dd/*.*)
	cd $*.dd && $(MAKE) $*.log
	$(CP) $*.dd/$*.log $@

