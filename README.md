# makestuff

Various makefiles for including, primarily intended for other git projects.

Very much core to @jd-mathbio's work flow; should be better supported for others

## Start simple

To install makestuff in an existing project, you can try the following.

* If you have a Makefile, move it: `mv Makefile content.mk`
* Clone this repo as a subdirectory: `git clone https://github.com/dushoff/makestuff.git`
* Get a simple Makefile: `cp makestuff/simple.mk Makefile`

That should be it. You should still be able to make anything you could make before, and at least some makestuff should be working. Let me know if this does or doesn't work for you

Next, you could look at your new Makefile and see what it says about moving old content (if any) and about including makestuff rules.

