
makeR is being developed here but meant to be an R package to do what wrapR does, but based more in R and more transparent. This will also mean it's a little less magic.

Overview
===========

We currently call makeR using:

`source("makestuff/makeRfuns.R")`

The default way to run makeR is:

* use `$(makeR)` as the recipe
* `source("makestuff/makeRfuns.R")` at the beginning
* use makeR functions to read environments and files (at the beginning of script)
* use makeR functions to save environments and files (at the end of script)

We then have functions for doing what wrapR used to do:
* reading or loading files named as dependencies
	* including loading them sometimes into separate environments or something
* saving environments and writing csv files

There is some parallel machinery for dealing automatically with rds files. This does _not_ have the big efficiency advantages that were advertised, but may still be worth saving for special purposes. In particular, rds could provide a better way to merge pipes in the future.

Looking at `makestuff/makeRfuns.R` and `makestuff/wrapmake.R` (see below) is a good way to get started on these functions

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

File conventions:
=================

images
* Default dumps (save.image) are called .rda (or .RData, for compatibility)
* Limited dumps (save) are called .rdata

objects
* rds
