## Makestuff

### Hooks for the editor to set the default target
current: target
-include target.mk

cmain = master

##################################################################

## 2020 Jul 05 (Sun): Think about how to partition this later 
## Do we want R files in this main directory)?
Sources += $(wildcard *.R)

Ignore += chain
Ignore += *.stamp

##################################################################

md = $(wildcard *.md)
Sources += $(md)
Ignore += $(md:md=html)

Sources += $(wildcard *.proj)

## Work on documentation!!!

## Make a list of .mk files that are here and go through them!

Ignore += README.gh.html
## README.gh.html: README.md

######################################################################

## Retrofits

## make noms (unix.mk) tries to get rid of $(ms) stuff
## in Makefile and in .mk files
## Do this by: making sure ms=makestuff is there (so that the rule and files will work); running the rule; probably deleting the now-useless def

######################################################################

# Base files

Sources += Makefile LICENSE README.md todo.md

Sources += $(wildcard *.mk *.pl *.Makefile *.def)

## New copy-able makefiles 2019 Aug 31 (Sat)
## simple.Makefile direct.Makefile

## Script to make exclude file
Sources += ignore.pl

## Inputs for .config ignore file (see git.mk)
Sources += ignore.auth ignore.vim ignore.lock

# Sources += os.mk unix.mk linux.mk windows.mk up.mk

######################################################################

# Scripts to do accounting via google sheets (inactive)

## Not clear what this was meant to be for 2018 Sep 22 (Sat)
## Seems clear that it's event spreadsheets, started at DAIDD 2019 Aug 31 (Sat)
# Sources += accounts.mk accounts.pl

######################################################################

# Git makefile stuff 
# Not so clear what's active or not

# Sources += git.mk git.def git.md repos.def repos.mk init.mk modules.mk drops.mk target.mk hybrid.mk hotcold.mk

# Makefiles and resources for other projects

# Sources += visual.mk compare.mk

# Sources += stepR.mk stepR.md
# Sources += rstep.pl rmdstep.pl

# Sources += resources.mk

# Sources += perl.def python.def

######################################################################

## Older attempts at latex. Should eliminate soon.

# Sources += newlatex.mk latexdeps.pl images.mk

# Sources += newlatex.mk latexdeps.pl biber.def bibtex.def

# Sources += flextex.mk flextex.pl deps.mk
# Sources += flextex.md

######################################################################

## Initializing at various levels

# Sources += $(wildcard hybrid/*)

######################################################################

## Current latex stuff

# Sources += latexdiff.pl
# Sources += texdeps.mk texdeps.pl texdeps.md
# Sources += simptex.mk

######################################################################

## Various talkish stuff. Need to find out what's hot, what's not.

Ignore += $(wildcard newtalk/*.deps)
Sources += $(wildcard newtalk/*.format newtalk/*.pl newtalk/*.sty newtalk/*.tex newtalk/*.tmp)
# Sources += linkdirs.mk newtalk.def newtalk.mk newtalk.md $(wildcard newtalk/*.*)

Sources += $(wildcard lect/*.*)

# Sources += pandoc.mk compare.mk render.mk

######################################################################

## Talk images stuff
# Sources += webpix.mk webtrans.mk
# Sources += webhtml.pl webmk.pl

######################################################################

## Caching
# Sources += cache.mk cache.md

######################################################################

## mkfiles

Sources += mkfiles.Makefile mkfiles.wrap

######################################################################

# wrapR scripts
## Deprecated 2021 May 03 (Mon)

Sources += $(wildcard wrapR/*.R) $(wildcard wrapR/*.pl)

## pdf manipulation
# Sources += wrapR/pdf.mk forms.def forms.mk wrapR/up.mk

## Make automatic wrapR master wrappers

# Sources += masterR.mk masterR.pl masterRfiles.pl masterR.md

## New autorefs stuff
Sources += autorefs.mk $(wildcard autorefs/*.pl) autorefs/Makefile autorefs.md

######################################################################

## Marginal .mk

## CIHR application tools
# Sources += cihrpaste.mk $(wildcard cihrScripts/*.*)

######################################################################


## Missing image tags
# Sources += missing.pdf personal.pdf
missing.pdf:
	echo "This image is not found in its original documented location" | groff | ps2pdf - > $@

personal.pdf:
	echo "This personal image is not found" | groff | ps2pdf - > $@

######################################################################

## WLS

Sources += WSL/*.sh
Sources += WSL.md

######################################################################

## Repos for gitroot

## Deprecate these. Also, maybe crib some more into repohome.list?
# Sources += repos/dushoff_repos.mk repos/friends.mk repos/sites.mk
# Sources += repos/dushoff_repos.def repos/friends.def

## repos for screens
Sources += repohome.list
# Sources += repohome.list repohome.mk repohome.pl
Ignore += repohome.auto.mk

######################################################################

-include unix.mk
-include local.mk
include git.mk
include gitbranch.mk
include pandoc.mk
include visual.mk
