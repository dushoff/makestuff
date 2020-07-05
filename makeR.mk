define makeR 
	((R --vanilla --args $@ $^ < $< > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

ifndef disable_automatic_makeR
.PRECIOUS: %.Rout
%.Rout: %.R
	$(makeR)
endif

%.rda %.rdata %.RData: %.Rout
	@ls $@ > /dev/null

