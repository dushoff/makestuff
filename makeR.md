
Automaticity
============

makeR is not automatic by default. If you want to make dumb.Rout from dumb.R (if it exists) without an explicit recipe, you need to set an automatic variable:

`automatic_makeR = something`

or

`wrap_makeR = something ## legacy mode`

Basic ideas
===========

makeR is meant to be a package, but for now we call it using 

`source("makestuff/makeRfuns.R")`

The default way to run makeR is:

* use `$(makeR)` as the recipe
	* you can use the `automatic_makeR` variable to make this a default for some applications
* `source("makestuff/makeRfuns.R")` at the beginning
* use makeR functions to read environments and files
* do something
* use makeR functions to save environments and files

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
	* you can use the `wrap_makeR` variable to make this a default for some applications
* Hope that it works similar enough to wrapR
	* Hybridizing (adding makeR functions to a script wrapped by wrapmake) seems to work fine in emergencies, but we should be moving towards making makeR explicit, I think.

2020 Jul 05 (Sun)
=================

This is meant to be a replacement for wrapR. I would like it to be backward compatible.

makeR is meant to be the main recipe
* it uses the first script dependency as the master script; this seems less alienating and may produce better log and out files

run-R is the backward-compatible recipe
* it uses a special-purpose script as the master script
	* script dependencies are sourced in order

File conventions:
* images
	* Default dumps (save.image) are called .rda (or .RData, for compatibility)
	* Limited dumps (save) are called .rdata
* objects
	* For now, call them all rds (I'm starting to worry about case issues!).
