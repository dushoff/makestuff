
presources: ~/Dropbox/resources/$(notdir $(CURDIR))
	(ls $< > /dev/null) && ln -s $< $@

dropdirs += presources

Ignore += $(pardirs)
Ignore += $(dropdirs)
