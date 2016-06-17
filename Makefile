### Makestuff

### Hooks for the editor to set the default target
current: target

target pngtarget pdftarget vtarget acrtarget: csv2html.py 

##################################################################

now:
	@echo $(BRANCH)

# Base files

Sources = Makefile LICENSE README.md .gitignore stuff.mk README.github.md todo.md

# Starting makefile for other projectcs

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

Sources += perl.def python.def

Sources += newlatex.mk latexdeps.pl RR/pdf.mk forms.mk RR/up.mk

Sources += talk.def talk.mk $(wildcard talk/*.*)

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
