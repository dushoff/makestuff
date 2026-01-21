Ignore += *.mac.out

## Not working and I can't parse 2024 Oct 22 (Tue)
%.mac.out: %.mac
	maxima -b $< > $@

Ignore += *.maxima
%.maxima: %.max
	maxima -b $< > $@
