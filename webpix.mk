### Rules for getting images from the web

### Sort of designed for a subdirectory (since it includes allsteps)
### But subdirectory does not need to be a repo, I guess...
### EXPERIMENTING: Don't include allsteps, but instead make a rule for when to use it

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

%.rmk:
	$(RM) $*
	$(MAKE) $*


## Use generated make rules appropriately
stepmks = $(steps:.step=.step.mk)
Makefile: allsteps.mk
allsteps.mk: $(stepmks)
	$(cat)

-include allsteps.mk
