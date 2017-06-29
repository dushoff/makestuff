Use `-include $(ms)/cache.mk` to enable simple caching. `cache.mk` is intended for files which are expensive to make, but not expensive to track.

# Basic idea

Slow targets are:
* made automatically, but not remade automatically
* added to the repo, so that they can be reverted, or shared between platforms
* designated using make rules

by having rules to _make_ them in one directory (`$(cachedir)`, `git_cache` by default) and rules to _use_ them in another (`$(slowdir)`, `slow` by default)
* `make` should just work as normal when slow targets don't exist

__Currently implemented only for `wrapR` targets; should be easy to extend__

To cache a file, require a cached version in a make rule:

```make
sump.Rout: git_cache/sum.Rout sump.R
```

This means that `sump.Rout` depends on `sum.Rout`, in more or less the usual way, but via `git_cache`:

* If a cached version of `sum.Rout` does not exist, it will be made the normal way and cached
* If the cached version does exist, it will not be remade as a step to making sump.Rout, unless you override the cache (do this with `make sump.Rout.nocache`)
* The cached version is meant to be pushed and pulled with the git repo
	* `cache.mk` should be included _before_ `git.mk` if you want makestuff to automatically add git_cache files.

Not sure how or whether this is going to work with Junling's stuff. Wanted to make it work first.

Currently implemented in [my horrible scratch repo](https://github.com/dushoff/scratch) (only check if you really find this unclear, you could also just complain).
