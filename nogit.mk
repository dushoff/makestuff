
## Main Dropbox makefile. The point is for screen_session
## Make it into a symlink and house it linux_config
## There should be a rule to spin it from there when setting up a new computer
## 2020 Jan 12 (Sun) Or not; need to think more comprehensively about Dropbox setup

-include target.mk

Makefile: makestuff/Makefile
	touch $@
makestuff/Makefile:
	ls ~/screens/makestuff/Makefile && /bin/ln -s ~/screens/makestuff 

-include makestuff/os.mk
-include makestuff/visual.mk
