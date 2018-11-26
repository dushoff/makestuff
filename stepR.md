(Development notes moved to Sandbox/stepR/notes.md)

stepR is meant to help gnu make co-ordinate R projects that were not written for that purpose. For simple projects, it can work as a drop-in.

stepR takes a pretty aggressive approach towards making and implementing make rules, and towards making assumptions about default targets.

.rdeps files are made automatically for each R file, and are automatically included as part of the make flow. 
* stepR does not process code following the magic word noStep

stepR tries to figure out sources and products by parsing out commands which _start with_ keywords listed at the top of makestuff/rstep.pl, and lines with the magic words stepSource or stepProduct

Magic words usually work when commented out in R (and should usually _be_ commented out in R, but can be suppressed with "##" at the beginning of the line.

stepR also has default products: 
* <basename>.Rout will generally be made when any script is run
* <basename>.Rout.pdf will be made from any script that leaves behind Rplots.pdf
* <basename>.RData will be made from any script that leaves behind .RData
These can be used for chaining.

It is a convention to name manually created R data files `.rda` and allow stepR to call things `.RData`.

stepR was first pushed Thanksgiving 2018. It is pre-α.

to use stepR, you should `include` makestuff/perl.def and makestuff/stepR.mk in your Makefile

If you want stepR without makestuff, you can copy makestuff/stepR.mk and makestuff/rstep.pl and then either copy makestuff/perl.def or make your own perl rule.

----------------------------------------------------------------------

TODO

