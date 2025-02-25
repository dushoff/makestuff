## Graphing (weird stuff, and acting weird for now)

Ignore += *.ndlog
%.ndlog: Makefile
	make -nd $* > $@

Ignore += *.cleanlog
%.cleanlog: %.ndlog
	cat $< | grep -v makestuff | grep -v "\.mk" | grep -v makedeps | grep -v subdeps > $@

%.fast.cleanlog: %.cleanlog
	cat $< | grep -v slowtarget > $@

Ignore += *.mg.dot
%.mg.dot: %.cleanlog
	make2graph $< > $@

Ignore += *.mg.pdf
%.pdf: %.dot
	dot -Tpdf -o $@ $<

## Does not chain through wildcard; also, the graph has unexplained orphanism
%.dd.cleanlog: %.dd.testsetup $(wildcard %.dd/*.*)
	cd $*.dd && $(MAKE) $*.cleanlog
	$(CP) $*.dd/$*.cleanlog $@

