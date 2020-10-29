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

define knitpdf
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", output_format="pdf_document", output_file="$@")' $^
endef

define knithtml
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", output_format="html_document", output_file="$@")' $^
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
	$(lscheck) || ($(pdfcheck) $@.tmp && $(MVF) $@.tmp $@) || (ls Rplots.pdf && echo WARNING: Trying an orphaned Rplots file && mv Rplots.pdf $@)

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

## Does rmd listen to commandArgs?

######################################################################

## Scripts
## Disentangle how things work, and empower people who don't use make
## Won't work in directories that need non-automatic setup

%.makeR.script:
	$(MAKE) cpdir.mslink
	cd cpdir && $(MAKE) -n $*.Rout > make.log
	perl -wf makestuff/makeRscript.pl cpdir/make.log > $@

Sources += $(wildcard *.makeR.script)
