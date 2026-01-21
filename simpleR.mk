
define rThere
	cd $(dir $<) && R --vanilla < $(notdir $<) > $(notdir $@)
	- $(MV) $(dir $<)/Rplots.pdf $@.pdf
endef
