**DEPRECATED** (wrapR only). For pipeR, use `make <goal>.pipeR.sh` (see pipeR.mk), e.g. `foo.Rout.pipeR.sh`, `foo.Rout.final.pipeR.sh`, `targets.pipeR.sh`.

Make master scripts so people without unix can run wrapR stuff. Ish.

wrapR has been mostly deprecated for pipeR, though.

To make a set of scripts, run `make <foo>.masterR`. This makes:
* <foo.master.R>, which calls a bunch of things called 
* <bars.run.r>, which are basically wrapR scripts that we want to push, these in turn call
* what the original scripts are (which users are free to edit, and this will work with the new pipeline).

The master script will try to report what it's trying to do, _including printing a comment block from the top of an R script that it's running_, if there is one.
