Use `-include $(ms)/cache.mk` to enable simple caching. `cache.mk` is intended for files which are expensive to make, but not expensive to track.

# Basic idea

Slow targets are:
* made automatically, but not remade automatically
* added to the repo, so that they can be reverted, or shared between platforms
* designated using make rules

In the make file, slow targets should be:
* _made_ in the cache directory (`$(cachedir)`, `git_cache` by default) 
* _used_ them from the slow directory (`$(slowdir)`, `slow` by default)

To do a complete make (not respecting the cache), say:
``` bash
make <target>.nocache
```

This seals up the breakpoint in your make logic (between the slow directory and the cache directory). It should always work within a local session, but I'm worried about time stamps when the repo is pushed and pulled. Will investigate further.

Here is some example code that seems to be working for me (in a repo with makestuff as a submodule):

```make
## Not very relevant, but maybe you're curious about PUSH
-include $(ms)/perl.def

git_cache/test.out: test.pl
	$(PUSH)

test.print: slow/test.out
	cat $< > $@

# Rename cache directories before you include cache.mk
# slowdir = datadir
-include $(ms)/cache.mk

# Include cache.mk before git.mk, if you want to auto-cache git cache (and conversely, I guess)
-include $(ms)/git.mk
