## Rules for making and using concat
## Work on comb.txt depedencies combine * and %?
.SECONDEXPANSION:
%.comb.txt: $$(wildcard $$*.?.mp4)
	ls $*.?.mp4 | perl -npe "s/.*/file '$$&'/" >  $@
%.edit.mp4:
	touch $@; $(MVF) $@ $*.tmp.mp4
	ffmpeg -f concat -i $(filter %.txt, $^) -codec copy $@

