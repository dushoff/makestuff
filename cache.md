
2019 Mar 13 (Wed)
=================

Starting over, and I basically have no principles I agree with.

We want to mark steps as slow, and not do slow steps by default.

----------------------------------------------------------------------

There was an older thing. It's hiding in the history. I'm not convinced I've done anything good so far. 

----------------------------------------------------------------------

We want to have rules for three types of make:

* fast: the default
* lazy: make if possible, but don't do anything marked as slow, unless it is necessary (buildcache)
* full: make updated targets, pay no attention to what is marked as slow (rebuildcache)

There's also a question about time stamps: it is hard to be sure that time stamps are consistent between platforms (or even within git, if we are pushing output files).

We want to mark targets as slow where we make them. We can do that by making them in a cache directory. In general, these should have weird names also, so that there is no other way to make them.
* This idea depends on assuming a flat directory structure for now
* Later we could use some sort of directory logic (like hide uses)

This whole project is a disaster, I think
