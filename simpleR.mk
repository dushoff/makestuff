
define rThere
	cd $(dir $@) && R --vanilla < $(notdir $<) > $(notdir $@)
	- $(MV) $(dir $@)/Rplots.pdf $@.pdf
endef

define rHere
	R --vanilla < $< > $@
	@($(MV) Rplots.pdf $@.pdf && echo also made $@.pdf) || echo no Rplots file found
endef
