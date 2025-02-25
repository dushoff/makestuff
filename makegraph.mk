## Graphing (weird stuff, and acting weird for now)

Ignore += *.nd.log
%.nd.log: Makefile
	make -nd $* > $@

Ignore += *.nom.log
%.nom.log: %.nd.log
	cat $< | grep -v makestuff | grep -v "\.mk" > $@

%.fast.log: %.log
	cat $< | grep -v slowtarget > $@

Ignore += *.mg.dot
%.mg.dot: %.log
	make2graph $< > $@

Ignore += *.mg.pdf
%.pdf: %.dot
	dot -Tpdf -o $@ $<

## Does not chain through wildcard; also, the graph has unexplained orphanism
%.dd.log: %.dd.testsetup $(wildcard %.dd/*.*)
	cd $*.dd && $(MAKE) $*.log
	$(CP) $*.dd/$*.log $@

