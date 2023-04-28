### Rules for getting images from the web

### Currently developing together with 3SS/Lectures
### Previously used with math_talks

Ignore += webpix my_images

steps = $(wildcard *.step)
Sources += $(steps)

Ignore += $(steps:%=%.mk)
%.step.mk: %.step makestuff/webmk.pl
	$(PUSH)

Ignore += $(steps:.step=.html)
%.html: %.step.mk makestuff/webhtml.pl webpix
	$(MAKE) -f $< -f makestuff/webtrans.mk images
	$(MAKE) -f $< -f makestuff/webtrans.mk thumbs
	$(PUSHSTAR)

webpix/%.png: webpix/%.svg
	convert $< $@

## Digest files
htmls =  $(steps:.step=.html)

## Grand overview file
Ignore += all.html
all.html: $(htmls)
	$(cat)

######################################################################

## Make a webpix directory (user should define or pay attention to imageDrop)
## I can't figure out where default imageDrop comes from!

## jd.local: jd.local.mk
Sources += $(wildcard *.local.mk)
%.local: | %.local.mk
	$(LN) $| local.mk
-include local.mk

webpix my_images: dir = $(imageDrop)
webpix my_images: 
	$(MAKE)  $(imageDrop)/$@
	$(linkdir)

$(imageDrop)/webpix $(imageDrop)/my_images:
	$(mkdir)

## Reload a figure if you messed up the link or something
%.remake:
	$(RM) $*
	$(MAKE) $*

## Use generated make rules appropriately
stepmks = $(steps:.step=.step.mk)
Ignore += allsteps.mk $(stepmks)
Makefile: allsteps.mk
allsteps.mk: $(stepmks)
	$(cat)

webpix/%: allsteps.mk
	$(MAKE) webpix
	$(MAKE) -f $< $@

my_images/%: my_images
	(cd $< && $(MAKE) $*) || convert $(word 2, $^) $@

## Make things that programs need?
%.gif.jpg: %.gif
	$(convert)
