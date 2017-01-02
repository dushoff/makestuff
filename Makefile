### Makestuff

### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget:  notarget

##################################################################

ms = ../makestuff

# Base files

Sources = Makefile LICENSE README.md .gitignore stuff.mk todo.md

# Starting makefile for other projects

Sources += makefile.mk hooks.mk

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

Sources += git.mk git.def repos.mk

# Makefiles and resources for other projects

Sources += visual.mk oldlatex.mk RR.mk wrapR.mk compare.mk

Sources += stepR.mk stepR.md
Sources += rstep.pl

Sources += resources.mk

Sources += perl.def python.def

Sources += newlatex.mk latexdeps.pl

Sources += newlatex.mk latexdeps.pl biber.def bibtex.def

Sources += flextex.mk flextex.pl deps.mk
Sources += flextex.md

Sources += RR/pdf.mk forms.mk RR/up.mk

Sources += talk.def talk.mk $(wildcard talk/*.*)

Sources += linkdirs.mk newtalk.def newtalk.mk $(wildcard newtalk/*.*)

Sources += lect.mk $(wildcard lect/*.*)

Sources += pandoc.mk compare.mk

######################################################################

# RR scripts

RRR = $(wildcard RR/*.R)
RRpl = $(wildcard RR/*.pl)

Sources += $(RRR) $(RRpl)

# wrapR scripts

wrapRR = $(wildcard wrapR/*.R)
wrapRpl = $(wildcard wrapR/*.pl)

Sources += $(wrapRR) $(wrapRpl)

include git.mk

######################################################################

# Developing newlatex

include perl.def
# include newlatex.mk

# test.pdf: test.tex latexdeps.pl

# .deps/test.tex.d: test.tex latexdeps.pl
