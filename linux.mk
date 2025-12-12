-include makestuff/unix.mk

open ?= xdg-open
usershell ?= bash

%.go:
	$(MAKE) $*
	echo "$(open) $* >& go.log &" | $(usershell)

%.acr:
	$(MAKE) $*
	acroread /a "zoom=165" $* &

%.png: %.pdf
	convert $< $@

