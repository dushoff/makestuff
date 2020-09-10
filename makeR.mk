pdfcheck = perl -wf makestuff/wrapR/pdfcheck.pl

define makeArgs
	echo "## callArgs Only works interactively and is target-dependent" > $@.args
	echo callArgs "<-" \"$@ $^\"  >> $@.args
	echo >> $@.args
endef

define makeR 
	-$(RM) $@ $@.*
	$(makeArgs)
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
	$(lscheck)

.PRECIOUS: %.rds %.Rds
%.rds %.Rds: %.Rout
	$(lscheck)

## .pdf.tmp is a pure intermediate; you should require .pdf, not .pdf.tmp
%.Rout.pdf.tmp %.Rout.png %.Rout.jpeg: %.Rout
	$(lscheck)

.PRECIOUS: %.Rout.csv
%.Rout.csv: %.Rout
	$(lscheck)

.PRECIOUS: %.Rout.pdf
%.Rout.pdf: %.Rout
	$(lscheck) || ($(pdfcheck) $@.tmp && $(MVF) $@.tmp $@)

Ignore += .Rhistory .RData
Ignore += *.RData *.Rlog *.rdata *.rda *.rtmp
Ignore += *.Rout*
Ignore += *.Rds *.rds

wrapdelete:
	$(RM) *.wrapR.* .*.wrapR.* 

######################################################################

## Horrible eval rules
## These are necessary so that we can chain through .rda and other products
## but specify dependencies centrally through .Rout

define impdep
%.$(1).rda: %.$(1).Rout ; $(lscheck)
%.$(1).rdata: %.$(1).Rout ; $(lscheck)
.PRECIOUS: %.$(1).rdata %.$(1).rda %.$(1).Rout
endef

$(foreach stem,$(impmakeR),$(eval $(call impdep,$(stem))))

## These rules are apparently only needed for make3?
## 2020 Aug 01 (Sat)

expR += $(wildcard *.R)
expmakeR += $(expR:%.R=%)

define expdep
$(1).rda: $(1).Rout ; $(lscheck)
$(1).rdata: $(1).Rout ; $(lscheck)
.PRECIOUS: $(1).rdata %.$(1).rda %.$(1).Rout
endef

$(foreach stem,$(expmakeR),$(eval $(call expdep,$(stem))))

######################################################################

## Scripts
## Disentangle how things work, and empower people who don't use make

## Is this used?? 2020 Sep 09 (Wed)
%.makeRproj.script:
	- $(RMR) dotdir
	$(MAKE) dotdir.mslink
	cd dotdir && $(MAKE) -n $*.Rout > make.log
	perl -wf makestuff/makeRscript.pl dotdir/make.log > $@

## Still messing with this: it warns if .makeR.script is a source, I think
%.makeR.script: cpdir.mslink
	$(MAKE) cpdir.mslink
	cd cpdir && $(MAKE) -n $*.Rout > make.log
	perl -wf makestuff/makeRscript.pl cpdir/make.log > $@

Sources += $(wildcard *.makeR.script)
