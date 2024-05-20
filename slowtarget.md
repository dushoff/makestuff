
The recommended makestuff way to deal with slow targets is with slowtarget.mk

It can be included in parallel with other makestuff includes

Once included, you can avoid remaking targets by:

* using slowtarget/ for the target
* using slow/ in parallel as a dependency 

e.g:
```make
slowtarget/foo.out: slow.script
	$(slowrecipe)
foo.pretty.png: slow/foo.out pretty.script
	$(prettyrecipe)
```

This should just work the first time (as if they were the same file). Subsequent times, the slow target should not be remade by default. To remake (or just make sure things are up to date) append '.final' to the target, as in `make foo.pretty.png.final`. Use `make -n` to just check without making anything.

When sharing with others, you will generally want to share the target files in slow (you should implement this in your own Makefile for flexibility; we don't want slowtarget posting your private data), but not in slowtarget (so that `make <target>.final` will make the whole project on the new machine (except for parts already made on that machine). Probably.

If you want to work on slow steps without remaking all of them, you can say `make slowsync` before you start to bring your slowtarget/ directory up-to-date with the version-controlled slow/ directory. This should mean that `make <target>.final` remakes things that are really new, but not up-to-date things that were made elsewhere.

## Issues

Automatic intermediaries (like .Rout) can be missed, and trigger unwanted making.

