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

## Make a webpix directory (user should define or pay attention to imageDrop)
## Drop is mapped for back-compatibility

ifeq ($(imageDrop),)
imageDrop = $(Drop)
endif

ifeq ($(imageDrop),)
imageDrop = .
endif

webpix my_images: dir = $(imageDrop)
webpix my_images: 
	$(MAKE)  $(imageDrop)/$@
	$(linkdir)

$(imageDrop)/webpix $(imageDrop)/my_images:
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

my_images/%: my_images
	(cd $< && $(MAKE) $*) || convert $(word 2, $^) $@
