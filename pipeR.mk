pdfcheck = perl -wf makestuff/wrapR/pdfcheck.pl

define makeArgs
	echo "## Use this call to make $@ independently" > $@.args
	echo "rpcall(\"$@ $^\")"  >> $@.args
	echo >> $@.args
endef

define pipeR
	-$(RM) $@ $@.*
	$(makeArgs)
	((R --vanilla --args $@ $^ < $(word 1, $(filter %.R, $^)) > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

## Back-compatility
makeR=$(pipeR)

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

define wrapR
	-$(RM) $@ $@.*
	((R --vanilla --args $@ $^ < makestuff/wrappipeR.R > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

run-R = wrapR

## Legacy
ifdef autowrapR
.PRECIOUS: %.Rout
%.Rout: %.R
	$(wrapR)
endif

## A reasonable default
ifdef autopipeR
.PRECIOUS: %.Rout
%.Rout: %.R
	$(pipeR)
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

.PRECIOUS: %.Rout.csv
%.Rout.csv: %.Rout
	$(lscheck)

## .pdf.tmp is a pure intermediate; you should require .pdf, not .pdf.tmp
%.Rout.pdf.tmp %.Rout.png %.Rout.jpeg %.ggp.pdf: %.Rout
	$(lscheck)
.PRECIOUS: %.Rout.pdf
%.Rout.pdf: %.Rout
	$(lscheck) || ($(pdfcheck) $@.tmp && $(MVF) $@.tmp $@) || (ls Rplots.pdf && echo WARNING: Trying an orphaned Rplots file && mv Rplots.pdf $@)

Ignore += .Rhistory .RData
Ignore += *.RData *.Rlog *.rdata *.rda *.rtmp
Ignore += *.Rout*
Ignore += *.Rds *.rds

######################################################################

## Eval rules for implicit dependencies
## These are necessary so that we can chain through .rda and other products
## but specify dependencies centrally through .Rout

define impdep_r
%.$(1).rda: %.$(1).Rout ; $(lscheck)
%.$(1).rdata: %.$(1).Rout ; $(lscheck)
.PRECIOUS: %.$(1).rdata %.$(1).rda %.$(1).Rout
endef

impmakeR += $(pipeRimplicit)
$(foreach stem,$(impmakeR),$(eval $(call impdep_r,$(stem))))

## Eval rules for "described" pdf files
define pipedesc_r
$(1).%.pdf: $(1).Rout ; $(lscheck)
Ignore += $(1).*.pdf
endef

$(foreach stem,$(pipeRdesc),$(eval $(call pipedesc_r,$(stem))))

######################################################################

## Deleting some rules that may be needed for make3?
## See makeR.mk
## 2021 Jan 05 (Tue)

######################################################################

## Scripts
## Disentangle how things work, and empower people who don't use make
## Won't work in directories that need non-automatic setup

%.pipeR.script:
	$(MAKE) cpdir.mslink
	cd cpdir && $(MAKE) -n $*.Rout > make.log
	perl -wf makestuff/makeRscript.pl cpdir/make.log > $@

Sources += $(wildcard *.pipeR.script)

