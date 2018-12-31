newcache is designed to replace cache (see makestuff/cache.md and makestuff/cache.mk)

It is meant to be agnostic about where you keep your cached files: typically either in a repo subdirectory or in a Drop folder of some kind)

We want to have rules for three types of make:

* fast: try to make, but don't do anything marked as slow
* lazy: make if possible, but don't do anything marked as slow, unless it is necessary
* full: make updated targets, pay no attention to what is marked as slow

One of these should be the default (not full, of course).

There's also a question about time stamps: it is hard to be sure that time stamps are consistent between platforms (or even within git, if we are pushing output files).

We want to mark targets as slow where we make them. We can do that by making them in a cache directory. In general, these should have weird names also, so that there is no other way to make them.
* This idea depends on assuming a flat directory structure for now
* Later we could use some sort of directory logic (like hide uses)

