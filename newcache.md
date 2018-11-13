newcache is designed to replace cache (see makestuff/cache.md and makestuff/cache.mk)

It is meant to be agnostic about where you keep your cached files: typically either in a repo subdirectory or in a Drop folder of some kind)

We want to have rules for three types of make:

* fast: try to make, but don't do anything marked as slow
* lazy: make if possible, but don't do anything marked as slow, unless it is necessary
* full: make updated targets, pay no attention to what is marked as slow

One of these should be the default (JD thinks fast, ML thinks full)
