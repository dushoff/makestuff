# makestuff

Various makefiles for including, primarily intended for other git projects.

Very much core to @jd-mathbio's work flow; should be better supported for others

## Start simple

To install makestuff in an existing project, you can try the following.

* If you have a Makefile, move it: `mv Makefile content.mk`
* Clone this repo as a subdirectory: `git clone https://github.com/dushoff/makestuff.git`
* Get a simple Makefile: `cp makestuff/simple.Makefile Makefile`

That should be it. You should still be able to make anything you could make before, and at least some makestuff should be working. Let me know if this does or doesn't work for you

Next, you could look at your new Makefile and see what it says about moving old content (if any) and about including makestuff rules.

## Files

### Usable
* [wrapR.mk](wrapR.mk) ([Documentation](wrapR.md))
* [stepR.mk](stepR.mk) ([Documentation](stepR.md))
* [texdeps.mk](texdeps.mk) ([Documentation](texdeps.md))

### Documented
* [autorefs.mk](autorefs.mk) ([Documentation](autorefs.md))
* [git.mk](git.mk) ([Documentation](git.md))
* [masterR.mk](masterR.mk) ([Documentation](masterR.md))
* [newtalk.mk](newtalk.mk) ([Documentation](newtalk.md))
* [webpix.mk](webpix.mk) ([Documentation](webpix.md))

### Documented but deprecated
* [cache.mk](cache.mk) ([Documentation](cache.md))
* [flextex.mk](flextex.mk) ([Documentation](flextex.md))

### Undocumented (some of these are simple and usable)
* [accounts.mk](accounts.mk)
* [apple.mk](apple.mk)
* [boot.mk](boot.mk)
* [cihrpaste.mk](cihrpaste.mk)
* [compare.mk](compare.mk)
* [deps.mk](deps.mk)
* [dirdir.mk](dirdir.mk)
* [exclude.mk](exclude.mk)
* [forms.mk](forms.mk)
* [hotcold.mk](hotcold.mk)
* [hybrid.mk](hybrid.mk)
* [images.mk](images.mk)
* [init.mk](init.mk)
* [knitr.mk](knitr.mk)
* [lect.mk](lect.mk)
* [linkdirs.mk](linkdirs.mk)
* [linux.mk](linux.mk)
* [modules.mk](modules.mk)
* [newlatex.mk](newlatex.mk)
* [newtarget.mk](newtarget.mk)
* [oldtalk.mk](oldtalk.mk)
* [os.mk](os.mk)
* [pandoc.mk](pandoc.mk)
* [projdir.mk](projdir.mk)
* [render.mk](render.mk)
* [repohome.auto.mk](repohome.auto.mk)
* [repohome.mk](repohome.mk)
* [repos.mk](repos.mk)
* [resources.mk](resources.mk)
* [rmd.mk](rmd.mk)
* [rmdweb.mk](rmdweb.mk)
* [simptex.mk](simptex.mk)
* [static.mk](static.mk)
* [submod.mk](submod.mk)
* [topdir.mk](topdir.mk)
* [unix.mk](unix.mk)
* [up.mk](up.mk)
* [visual.mk](visual.mk)
* [webtrans.mk](webtrans.mk)
* [windows.mk](windows.mk)
