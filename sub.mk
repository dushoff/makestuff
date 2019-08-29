ms = makestuff
-include local.mk
-include makestuff/os.mk

Sources += $(ms)

Makefile: $(ms)
$(ms):
	git submodule add -b master https://github.com/dushoff/$@.git

makestuff/%.mk: $(ms)/Makefile
	touch $@

makestuff/Makefile:
	git submodule init $(ms) 
	git submodule update $(ms) 
	touch $@
