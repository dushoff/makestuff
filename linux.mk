-include makestuff/unix.mk

%.go:
	$(MAKE) $*
	echo "xdg-open $* >& go.log &" | bash

%.acr:
	$(MAKE) $*
	acroread /a "zoom=165" $* &

%.png: %.pdf
	convert $< $@

