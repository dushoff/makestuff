## This is simply to facilitate auto-completion of `make <screendir>.vscreen` in bash. Probably not important, and obviously depends on other machinery 2021 Oct 23 (Sat)

vscreens = $(screendirs:%=%.vscreen)
newscreens = $(screendirs:%=%.newscreen)

## Completion file

Ignore += dirnames.mk
dirnames.mk: screens.mk
	echo $(vscreens) : > $@

-include dirnames.mk
