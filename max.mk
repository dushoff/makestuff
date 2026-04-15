Ignore += *.mac.out

## Not working and I can't parse 2024 Oct 22 (Tue)
Ignore += *.mac.out
%.mac.out: %.mac
	maxima -b $< > $@

## Delete?
Ignore += *.maxima
## %.maxima: %.max; maxima -b $< > $@
