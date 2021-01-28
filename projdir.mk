
presources: ~/Dropbox/resources/$(notdir $(CURDIR))
	(ls $< > /dev/null) && ln -s $< $@

~/Dropbox/resources/$(notdir $(CURDIR)):
	$(mkdir)

dropdirs += presources

Ignore += $(pardirs)
Ignore += $(dropdirs)
