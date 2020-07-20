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

ifdef wrap_makeR
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

.PRECIOUS: %.rda %.rdata %.RData
%.rda %.rdata %.RData: %.Rout
	@ls $@ > /dev/null

.PRECIOUS: %.rds %.Rds
%.rds %.Rds: %.Rout
	@ls $@ > /dev/null

## This is a pure intermediate; require .pdf, not .pdf.tmp
%.Rout.pdf.tmp %.Rout.png %.Rout.jpeg: %.Rout
	@ls $@ > /dev/null

.PRECIOUS: %.Rout.csv
%.Rout.csv: %.Rout
	@ls $@ > /dev/null

.PRECIOUS: %.Rout.pdf
%.Rout.pdf: %.Rout
	@ls $@ > /dev/null || ($(pdfcheck) $@.tmp && $(MVF) $@.tmp $@)

Ignore += .Rhistory .RData
Ignore += *.RData *.Rlog *.rdata *.rda *.rtmp
Ignore += *.Rout*
Ignore += *.Rds *.rds

wrapdelete:
	$(RM) *.wrapR.* .*.wrapR.* 

