
### Rules for getting stuff

steps = $(wildcard *.step)
Sources += $(steps)

%.step.mk: %.step $(ms)/webmk.pl
	$(PUSH)

%.html: %.step.mk $(ms)/webhtml.pl
	$(MAKE) -f $< -f $(ms)/webthumbs.mk images
	$(MAKE) -f $< -f $(ms)/webthumbs.mk thumbs
	$(PUSHSTAR)

## Generic transformations
%.png: %.svg
	convert $< $@

%.png: %.gif
	convert $< $@

## Digest files
htmls =  $(steps:.step=.html)

## Grand overview file
all.html: $(htmls)
	$(cat)

## Make a webpix directory (user should define or pay attention to Drop)
files: $(Drop)/webpix
	$(forcelink)

$(Drop)/webpix:
	$(mkdir)

Makefile: files

## Include generated make rules for these files
Makefile: allsteps.mk

%.rmk:
	$(RM) $*
	$(MAKE) $*

stepmks = $(steps:.step=.step.mk)
allsteps.mk: $(stepmks)
	$(cat)

-include allsteps.mk
