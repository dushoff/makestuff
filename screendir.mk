
vscreens = $(screendirs:%=%.vscreen)

## Completion file

dirnames.mk: Makefile
	echo $(vscreens) : > $@

-include dirnames.mk
