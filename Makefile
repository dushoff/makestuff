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

Sources += Makefile LICENSE README.md .gitignore static.mk sub.mk todo.md

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

Sources += visual.mk compare.mk

Sources += stepR.mk stepR.md
Sources += rstep.pl

Sources += resources.mk

Sources += perl.def python.def

######################################################################

## Older attempts at latex. Should eliminate soon.

Sources += newlatex.mk latexdeps.pl images.mk

Sources += newlatex.mk latexdeps.pl biber.def bibtex.def

Sources += flextex.mk flextex.pl deps.mk
Sources += flextex.md


######################################################################

## Current latex stuff

Sources += latexdiff.pl
Sources += texdeps.mk texdeps.pl texdeps.md
Sources += simptex.mk

######################################################################

## Various talkish stuff. Need to find out what's hot, what's not.

Sources += linkdirs.mk newtalk.def newtalk.mk $(wildcard newtalk/*.*)

Sources += lect.mk $(wildcard lect/*.*)

Sources += pandoc.mk compare.mk

######################################################################

## Talk images stuff
Sources += webpix.mk webtrans.mk
Sources += webhtml.pl webmk.pl

######################################################################

## Caching
Sources += cache.mk cache.md

######################################################################

# wrapR scripts

wrapRR = $(wildcard wrapR/*.R)
wrapRpl = $(wildcard wrapR/*.pl)

Sources += wrapR.mk $(wrapRR) $(wrapRpl)

## pdf manipulation
Sources += wrapR/pdf.mk forms.def forms.mk wrapR/up.mk

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
