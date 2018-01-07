ms = makestuff
-include local.mk
-include $(ms)/os.mk

Sources += $(ms)

Makefile: $(ms)
$(ms):
	git submodule add -b master https://github.com/dushoff/$@.git

$(ms)/%.mk: $(ms) $(ms)/Makefile
	touch $@

$(ms)/Makefile:
	git submodule update --init $(ms) 
	touch $@
