
vscreens = $(screendirs:%=%.vscreen)

## Completion file

Ignore += dirnames.mk
dirnames.mk: screens.mk
	echo $(vscreens) : > $@

-include dirnames.mk
