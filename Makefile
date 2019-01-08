### Makestuff

### Hooks for the editor to set the default target
current: target
-include target.mk

export ms = ./
-include $(ms)/os.mk

##################################################################

md = $(wildcard *.md)
Sources += $(md)
Ignore += $(md:md=html)

## Work on documentation!!!

## cache.html: cache.md

######################################################################

# Base files

Sources += Makefile LICENSE README.md static.mk sub.mk todo.md

## Script to make exclude file
Sources += ignore.pl

## Inputs for .config ignore file
Sources += ignore.auth ignore.vim

Sources += os.mk unix.mk linux.mk windows.mk up.mk

######################################################################

# Scripts to do accounting via google sheets (inactive)

## Not clear what this was meant to be for 2018 Sep 22 (Sat)
Sources += accounts.mk accounts.pl

######################################################################

# Git makefile stuff 
# Not so clear what's active or not

Sources += git.mk git.def git.md repos.def repos.mk init.mk modules.mk drops.mk target.mk hybrid.mk hotcold.mk

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

## Initializing at various levels

Sources += $(wildcard hybrid/*)

######################################################################

## Current latex stuff

Sources += latexdiff.pl
Sources += texdeps.mk texdeps.pl texdeps.md
Sources += simptex.mk

######################################################################

## Various talkish stuff. Need to find out what's hot, what's not.

Sources += linkdirs.mk newtalk.def newtalk.mk newtalk.md $(wildcard newtalk/*.*)

Sources += lect.mk $(wildcard lect/*.*)

Sources += pandoc.mk compare.mk render.mk

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

## Make automatic wrapR master wrappers

Sources += masterR.mk masterR.pl masterRfiles.pl masterR.md

## New autorefs stuff
Sources += autorefs.mk $(wildcard autorefs/*.pl) autorefs/Makefile autorefs.md

######################################################################

## Missing image tags
Sources += missing.pdf personal.pdf
missing.pdf:
	echo "This image is not found in its original documented location" | groff | ps2pdf - > $@

personal.pdf:
	echo "This personal image is not found" | groff | ps2pdf - > $@

######################################################################

Sources += repos/dushoff_repos.mk repos/friends.mk repos/sites.mk
Sources += repos/dushoff_repos.def repos/friends.def

######################################################################

-include local.mk
include git.mk
include pandoc.mk
include visual.mk
