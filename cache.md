
2020 Jul 03 (Fri)
=================

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


----------------------------------------------------------------------

TODO
====

## wrapR
* Special rules for .rds

## Make variables

* buildcache
* pipecache
* checkcache
