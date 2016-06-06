%.setgoal: %
	/bin/cp $@ $*.goal

%.goal: 
	/bin/cp $* $@

%.compare: % %.goal
	diff $* $*.goal > $@

