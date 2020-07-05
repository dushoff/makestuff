define makeR 
	((R --vanilla --args $@ $^ < $(word 1, $(filter %.R, $^)) > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

define run-R 
	((R --vanilla --args $@ $^ < makestuff/wrapmake.R > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

ifdef runmake
.PRECIOUS: %.Rout
%.Rout: %.R
	$(run-R)
endif

ifdef automatic_makeR
.PRECIOUS: %.Rout
%.Rout: %.R
	$(makeR)
endif

%.rda %.rdata %.RData: %.Rout
	@ls $@ > /dev/null

%.rds %.Rds: %.Rout
	@ls $@ > /dev/null

Ignore += .Rhistory .RData
Ignore += *.RData *.Rlog *.rdata *.rda
Ignore += *.Rout*
Ignore += *.Rds *.rds

