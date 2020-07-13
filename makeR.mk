pdfcheck = perl -wf makestuff/wrapR/pdfcheck.pl

define makeR 
	-$(RM) $@ $@.*
	((R --vanilla --args $@ $^ < $(word 1, $(filter %.R, $^)) > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

define run-R 
	-$(RM) $@ $@.*
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

## If no recipe, then this doesn't work
## If there is a recipe, it never resolves
## Use sparingly (or only for development)
%.manual: %
	touch $@

%.rda %.rdata %.RData: %.Rout
	@ls $@ > /dev/null

%.rds %.Rds: %.Rout
	@ls $@ > /dev/null

%.Rout.pdf.tmp %.Rout.png %.Rout.jpeg: %.Rout
	@ls $@ > /dev/null

%.Rout.csv: %.Rout
	@ls $@ > /dev/null

%.Rout.pdf: %.Rout
	@ls $@ > /dev/null || ($(pdfcheck) $@.tmp && $(MVF) $@.tmp $@)

Ignore += .Rhistory .RData
Ignore += *.RData *.Rlog *.rdata *.rda
Ignore += *.Rout*
Ignore += *.Rds *.rds

