`wrapR.mk` and the `wrapR/` directory are supposed to help pipeline R scripts.

`wrapR.mk` has a rule that wraps R scripts in some simple code, and produces `.Rout` and `.RData` files that can be used in subsequent scripts.

`wrapR.mk` is intended for complicated, piped projects where you don't always want to specify input and output files by name, and where the same script might be run on different inputs (to produce different outputs). It has a simpler sibling, `stepR.mk` which is designed to impose a make flow on more standard R projects.

Ben Bolker has proposed the idea, which I like, of making wrapR more transparent by making an R package to do most of what the wrapR wrapper does.

## Rules

`wrapR.mk` will run an `.R` file to (try to) produce `.Rout`, `.RData`, `.Rout.pdf`, `.Rout.csv` and maybe some other things

It can do this by default, and handle simple dependencies. But for complicated pipelines, you're often better off to help make's chaining and sense of order by adding an explicit `$(run-R)` recipe line after the dependency line

## wrapper.pl

`makestuff/wrapR/wrapper.pl` is the workhorse of the wrapR machinery.  It makes a wrapped R file that:

1) takes dependency file names from make and tries to figure out what R should be doing with them:
* `.RData` files are loaded into the environment
	* `.Rout` files are proxies for corresponding `.RData` files
	* `.env`, `.rda` and `Rdata` are synonyms for `.RData`
* `.R` files are sourced in the order that they come from make (`$(run-r)` can often clarify this order
* `.envir` files are put into an environment list
* all other dependency files are put into an inputs list

2) Creates names for output files based on the target (so that one script can be run in more than one part of the pipeline). These are:
* rtargetname <target>
* csvname <target>.Rout.csv
* pdfname <dottarget>.Rout.pdf
* rdsname <dottarget>.Rds
* rdaname <dottarget>.RData

The <dottarget> is an attempt to make a hidden file (requested by Mike Li). `wrapR.mk` is supposed to understand how to make these dependencies, and how to unhide them when necessary.

3) By default, saves the whole environment at the end of a completed run (no quit statement) into a hidden .RData file. To overrule this, use 

`# rdsave(…)` This works like save, but saves to the default hidden .RData file
`# rdnosave()`

Recommended style is to put a single comment character in case the script will ever be run in a different context. More than one comment character will actually comment out the line.
