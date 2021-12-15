## 2021 Jun 10 (Thu) notess
## Normally you should be able to just use .compare
## Use .setgoal to update an existing goal file

Ignore += *.compare *.goal

%.compare: % %.goal
	diff $* $*.goal > $@

.PRECIOUS: %.goal
%.goal: 
	/bin/cp $* $@

%.setgoal: %
	/bin/cp -f $* $*.goal
