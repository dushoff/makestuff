
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
