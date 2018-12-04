
Start a repo manually
---------------------

* Clone the repo
* Copy to the Makefile:
	* __either__ [start.mk](https://github.com/dushoff/gitroot/blob/master/start.mk) (clones makestuff, simpler)
	* __or__ [sub.mk](https://github.com/dushoff/gitroot/blob/master/sub.mk)  (makestuff as a submodule, more replicable) 
* `make makestuff`
* `make sync`
