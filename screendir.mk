
vscreens = $(screendirs:%=%.vscreen)

## Completion file

Ignore += dirnames.mk
dirnames.mk: Makefile
	echo $(vscreens) : > $@

-include dirnames.mk
