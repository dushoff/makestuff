### Rules for getting images from the web

### Sort of designed for a subdirectory (since it includes allsteps)
### But subdirectory does not need to be a repo, I guess...
### EXPERIMENTING: Don't include allsteps, but instead make a rule for when to use it

steps = $(wildcard *.step)
Sources += $(steps)

%.step.mk: %.step $(ms)/webmk.pl
	$(PUSH)

%.html: %.step.mk $(ms)/webhtml.pl
	$(MAKE) -f $< -f $(ms)/webtrans.mk images
	$(MAKE) -f $< -f $(ms)/webtrans.mk thumbs
	$(PUSHSTAR)

## Generic transformations
%.png: %.svg
	convert $< $@

%.png: %.gif
	convert $< $@

%.png: %.pdf
	convert $< $@

## Digest files
htmls =  $(steps:.step=.html)

## Grand overview file
all.html: $(htmls)
	$(cat)

## Make a webpix directory (user should define or pay attention to Drop)
## WARNING, files directory no longer supported!!
## Eliminate from rule some time
files webpix: $(Drop)/webpix
	$(forcelink)

$(Drop)/webpix:
	$(mkdir)

## Reload a figure if you messed up the link or something
%.rmk:
	$(RM) $*
	$(MAKE) $*

## Use generated make rules appropriately
stepmks = $(steps:.step=.step.mk)
Makefile: allsteps.mk
allsteps.mk: $(stepmks)
	$(cat)

webpix/%: allsteps.mk
	$(MAKE) -f $< $@

# -include allsteps.mk

