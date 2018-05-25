### Rules for getting images from the web

### Currently developing together with 3SS/Lectures
### Previously used with math_talks

Ignore += webpix my_images

steps = $(wildcard *.step)
Sources += $(steps)

Ignore += $(steps:%=%.mk)
%.step.mk: %.step $(ms)/webmk.pl
	$(PUSH)

Ignore += $(steps:.step=.html)
%.html: %.step.mk $(ms)/webhtml.pl webpix
	$(MAKE) -f $< -f $(ms)/webtrans.mk images
	$(MAKE) -f $< -f $(ms)/webtrans.mk thumbs
	$(PUSHSTAR)

## Digest files
htmls =  $(steps:.step=.html)

## Grand overview file
Ignore += all.html
all.html: $(htmls)
	$(cat)

######################################################################

## Make a webpix directory (user should define or pay attention to Drop)
## WARNING, files directory no longer supported!!

ifeq ($(Drop),)
Drop = ~/Dropbox
endif
webpix my_images: dir = $(Drop)
webpix my_images: 
	$(MAKE)  $(Drop)/$@
	$(linkdir)

$(Drop)/webpix $(Drop)/my_images:
	$(mkdir)

## Reload a figure if you messed up the link or something
%.rmk:
	$(RM) $*
	$(MAKE) $*

## Use generated make rules appropriately
Ignore += allsteps.mk
stepmks = $(steps:.step=.step.mk)
Makefile: allsteps.mk
allsteps.mk: $(stepmks)
	$(cat)

webpix/%: allsteps.mk webpix
	$(MAKE) -f $< $@

