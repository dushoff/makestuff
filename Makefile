### Makestuff

### Hooks for the editor to set the default target
current: target
-include target.mk

##################################################################
## Work on documentation!!!

cache.html: cache.md

######################################################################

include makestuff.mk

# Base files

Sources = Makefile LICENSE README.md .gitignore static.mk sub.mk todo.md

# Starting makefile for other projects

Sources += makefile.mk hooks.mk makestuff.mk

# Bootstrap stuff
# Want to be able to change this stuff locally
%.mk: %.mk.template
	$(CP) $< $@

Sources += os.mk unix.mk linux.mk windows.mk up.mk

######################################################################

# Accounts 

Sources += accounts.mk accounts.pl

### TEMP
include accounts.mk

######################################################################

# Git makefile for this and other projects

Sources += git.mk git.def repos.def repos.mk init.mk modules.mk drops.mk target.mk

# Makefiles and resources for other projects

Sources += visual.mk oldlatex.mk RR.mk wrapR.mk compare.mk

Sources += stepR.mk stepR.md
Sources += rstep.pl

Sources += resources.mk

Sources += perl.def python.def

Sources += newlatex.mk latexdeps.pl images.mk talktex.mk

Sources += latexdiff.pl

Sources += newlatex.mk latexdeps.pl biber.def bibtex.def

Sources += flextex.mk flextex.pl deps.mk
Sources += flextex.md

Sources += RR/pdf.mk forms.def forms.mk RR/up.mk

## Sources += oldtalk.def oldtalk.mk $(wildcard oldtalk/*.*)

Sources += linkdirs.mk newtalk.def newtalk.mk $(wildcard newtalk/*.*)

Sources += lect.mk $(wildcard lect/*.*)

Sources += pandoc.mk compare.mk

Sources += cache.mk cache.md

## Moving Lecture_images machinery here, so it can be used by others
Sources += webpix.mk webthumbs.mk
Sources += webhtml.pl webmk.pl

######################################################################

# RR scripts

RRR = $(wildcard RR/*.R)
RRpl = $(wildcard RR/*.pl)

Sources += $(RRR) $(RRpl)

# wrapR scripts

wrapRR = $(wildcard wrapR/*.R)
wrapRpl = $(wildcard wrapR/*.pl)

Sources += $(wrapRR) $(wrapRpl)

######################################################################

## Missing image tags
Sources += missing.pdf personal.pdf
missing.pdf:
	echo "This image is not found in its original documented location" | groff | ps2pdf - > $@

personal.pdf:
	echo "This personal image is not found" | groff | ps2pdf - > $@

######################################################################

-include local.mk
include git.mk
include pandoc.mk
include visual.mk

# Developing newlatex

include perl.def
# include newlatex.mk

# test.pdf: test.tex latexdeps.pl

# .deps/test.tex.d: test.tex latexdeps.pl
