%.mc.out: %.mc
	maxima -b $< > $@
