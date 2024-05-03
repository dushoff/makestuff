
slowtarget.mk (see slowtarget.md) is now the recommended way to do things

----------------------------------------------------------------------

Older stuff below, maybe delete it!

## 2023 Apr 15 (Sat)

Starting again from scratch!

timecache seems easy to make, but unbeautiful (it works like cacheflow, identifying slow dependencies). Would be better to mark slow targets

makestuff/slowtarget.mk tries to do that. But it seems basically impossible to do without special marking for each slow rule, which I have been avoiding. The problem is that chaining would require a catch-all rule?

## 2020 Jul 04 (Sat)

Redoing everything again

cacheflow.mk for checkvalves

cacherepo for a disposable cache repo

Everything is called "cachestuff" this can be retrofitted using ifndef later, but probably won't be

----------------------------------------------------------------------

# Old 2020 Jul 04 (Sat)

## Base

* ONE directory (cache/)
* NEVER have a Makefile rule that points there

Rules to _make_ slow files should _not_ change when caching is introduced
* instead, avoid directly making them

`slow.RData: good.dat slow.R`

Rules to _use_ slow files should request them from the cache

`final.Rout: cache/slow.RData`

To actually _make_ a slow file, use `.cache`:
`make slow.RData.cache`

2020 Jul 03 (Fri): This is now supposed to play nicely with the wrapR .Rout/.RData duality. Please let me know if not.

----------------------------------------------------------------------

TODO
====

## wrapR
* Special rules for .rds

## Make variables

* buildcache
* pipecache
* checkcache
