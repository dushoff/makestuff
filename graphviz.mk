## Graphviz figures: write foo.gv, include foo.gv.pdf (or foo.gv.png)
## Projects should add their sources: Sources += $(wildcard *.gv)
## makegraph.mk has a separate rule for generated make-dependency graphs (.mg.dot)

Ignore += *.gv.pdf *.gv.png

%.gv.pdf: %.gv
	dot -Tpdf -o $@ $<

%.gv.png: %.gv
	dot -Tpng -Gdpi=300 -o $@ $<
