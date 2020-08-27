
makeR is being developed here but meant to be an R package to do what wrapR does, but based more in R and more transparent. This will also mean it's a little less magic.

Quick start
===========

* Change dependencies to `rda` (full environment) or `rdata` (saveVars)
* Change the recipe to $(makeR)
* If you are using a pattern rule, say `impmakeR += <stem>`
* At the top
	* `source("makestuff/makeRfuns.R")`
	* `commandFiles()`
	* `makeGraphics()` __if__ you have graphics
* At the bottom
	* saveVars(vars to save) __or__
	* saveEnvironment() (if you are feeling lazy)
* There is an empty script for starting "real" makeR at makestuff/makeRex.R

Overview
===========

We currently call makeR using:

`source("makestuff/makeRfuns.R")`

i.e. this should be included (if not using legacy workflow) in every R script that will be using this machinery. The default way to run makeR is:

* use `$(makeR)` as the recipe in the Makefile
* `source("makestuff/makeRfuns.R")` at the beginning of the R script
* use makeR functions to read environments and files (at the beginning of script)
* use makeR functions to save environments and files (at the end of script)

We then have functions for doing what wrapR used to do:

* reading or loading files named as dependencies
	* including loading them sometimes into separate environments or something
* saving environments and writing csv files

There is some parallel machinery for dealing automatically with rds files. This does _not_ have the big efficiency advantages that were advertised, but may still be worth saving for special purposes. In particular, rds could provide a better way to merge pipes in the future.

Looking at `makestuff/makeRfuns.R` and `makestuff/wrapmake.R` (see below) is a good way to get started on these functions

**fixme**: add a non-legacy example??

Startup functions
==============

_commandEnvironments()_ reads any environments that were passed through the command line. It takes an exts argument. Default extensions are c("RData", "rda", "rdata")

_sourceFiles()_ sources .R files passed through the command line. It has a default of first=FALSE to ignore the first script, which by convention is the main script for the run

_makeGraphics()_ sets up the graphics to print to a default location (almost always .Rout.pdf; other things will work fine with R, but maybe not chain with make FIXME). It has a weird back-compatible default of writing the pdf file to .pdf.tmp, which make handles very nicely, but you can also say makeGraphics(otype="pdf") to make your file structure a bit more beautiful (TEST). It takes other arguments (and passes them to the graphics call). It should also work fine to make multiple files when called in ways that imply different file names.

_commandFiles()_ is a convenience function that wraps the three things above in some sort of sensible way (and takes advantage of the .pdf.tmp thing).

Legacy
======

The legacy approach wraps R files with `makestuff/wrapmake.R` to make makeR work like wrapR

The legacy way to run makeR is:

* use `$(run-R)` as the recipe
* Hope that it works similar enough to wrapR
	* Hybridizing (adding makeR functions to a script wrapped by wrapmake) seems to work fine in emergencies, but we should be moving towards making makeR explicit, I think.

Automaticity
============

makeR is not automatic by default. If you want to make dumb.Rout from dumb.R (if it exists) without an explicit recipe, you need to set an automatic variable:

`automatic_makeR = something`

or

`wrap_makeR = something ## legacy mode`

The Calibrators convention is to set this if you want to short-cut but _never_ use it with dependencies (if you need a rule, explicitly say $(makeR))

File conventions:
=================

images
* Default dumps (save.image) are called .rda (or .RData, for compatibility)
* Limited dumps (save) are called .rdata

objects
* rds

Problem
=======

2020 Jul 20 (Mon)

Rout is the standard target and that's who we want to tell about the dependencies. But this means that things won't chain through .rda. So there are two choices:

* use Rout as a fake dependency (this still has chaining problems, though)
* make horrible eval rules in makeR.mk so that it chains anyway

This is apparently solved now with eval rules. Less transparent than I would like, but seems robust enough. See impmakeR above.
