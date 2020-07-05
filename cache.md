
## 2020 Jul 04 (Sat)

Redoing everything again

cacheflow.md for checkvalves

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
