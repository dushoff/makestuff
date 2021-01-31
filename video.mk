## Rules for making and using concat in ffmpeg
## Work on comb.txt depedencies combine * and %?

Ignore += *.mp4 *.comb.txt

.SECONDEXPANSION:
%.comb.txt: $$(wildcard $$*.?.mp4)
	ls $*.?.mp4 | perl -npe "s/.*/file '$$&'/" >  $@
%.edit.mp4:
	touch $@; $(MVF) $@ $*.tmp.mp4
	ffmpeg -f concat -i $(filter %.txt, $^) -codec copy $@

