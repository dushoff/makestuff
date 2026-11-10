texk.mk replaces texj.mk. To switch a project, change `-include makestuff/texj.mk` to `-include makestuff/texk.mk`, and delete any `outer.texdeps.mk: inner.texdeps.mk` lines (no longer needed).

## How it works

`texk.pl` scans `filename.tex`, follows `\input` and `\include` recursively, and writes one flat file, `filename.texk.mk`, listing everything the document depends on at any depth: inputs, pictures (`\includegraphics`) and bib files. That file says to rescan whenever any of the scanned .tex files changes.

The main Makefile never loads `filename.texk.mk`. Making `filename.pdf` runs a sub-make that loads it:

* `filename.tex.deps` is touched when any dependency changes (and makes the dependencies first, so pictures exist before latex runs)
* `filename.repeat` runs latex when `filename.tex.deps` or `filename.aux` is newer, and marks the .aux as new if the log says "Rerun to"

So `filename.pdf` is never up to date for the main Makefile, but nothing happens unless something changed.

Inputs that are made by rules (e.g., `\input{table.Rout.tex}`) work: make builds them while remaking `filename.texk.mk`, then rescans them.

## Targets

* `filename.pdf`: one latex pass, if anything changed
* `filename.texfinal`: repeat until latex stops asking for reruns (at most 5 passes); `filename.texfinal.pdf` copies the result
* `filename.force.pdf`: run through errors if possible

## Limitations

* The scanner uses regular expressions: it does not see inputs hidden inside macros, or inputs in a different directory via `\graphicspath` or `\import`
* Paths are taken relative to the directory where latex runs (as latex does), at any depth
* Put `no_texdeps` in a comment to skip a file

_Warning:_ If you find some other way to get the text “Rerun to” into the tex log file, `texfinal` will run 5 times and then complain.
