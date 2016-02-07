-include $(ms)/unix.mk

%.go:
	$(MAKE) $*
	echo "xdg-open $* &" | tcsh

%.acr:
	$(MAKE) $*
	acroread /a "zoom=165" $* &

%.png: %.pdf
	convert $< $@

