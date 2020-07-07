Ignore += *.texcount *.wc
%.texcount: %
	texcount $< > $@
%.wc: %
	wc $< > $@
