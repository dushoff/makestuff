Make master scripts so people without unix can run wrapR stuff. Ish.

To make a set of scripts, run `make <foo>.masterR`. This makes:
* <foo.master.R>, which calls a bunch of things called 
* <bars.run.r>, which are basically wrapR scripts that we want to push, these in turn call
* what the original scripts are (which users are free to edit, and this will work with the new pipeline).

