### Rules for getting images from the web

### Currently developing together with 3SS/Lectures
### Previously used with math_talks

### Lives in main directory now … use allsteps only as needed

steps = $(wildcard *.step)
Sources += $(steps)

%.step.mk: %.step $(ms)/webmk.pl
	$(PUSH)

%.html: %.step.mk $(ms)/webhtml.pl
	$(MAKE) -f $< -f $(ms)/webtrans.mk images
	$(MAKE) -f $< -f $(ms)/webtrans.mk thumbs
	$(PUSHSTAR)

## Digest files
htmls =  $(steps:.step=.html)

## Grand overview file
all.html: $(htmls)
	$(cat)

######################################################################

## Make a webpix directory (user should define or pay attention to Drop)
## WARNING, files directory no longer supported!!

ifeq ($(Drop),)
Drop = ~/Dropbox
endif
webpix: dir = $(Drop)
webpix: $(Drop)/webpix
	$(linkdir)

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

