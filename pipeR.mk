pdfcheck = perl -wf makestuff/wrapR/pdfcheck.pl

define makeArgs
	echo "## Use this call to make $@ independently" > $@.args
	echo "rpcall(\"$@ $^\")"  >> $@.args
	echo >> $@.args
endef

define pipeR
	-$(RM) $@ $@.*
	$(makeArgs)
	((R --vanilla --args $@ shellpipes $*.pipestar $^ < $(word 1, $(filter %.R, $^)) > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

## Make the rpcall first so that we don't outdate things
define pipeRcall
	perl -wf makestuff/pipeRcall.pl $@ $^
	$(pipeR)
endef

## Back-compatility
makeR=$(pipeR)

define knitpdf
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", output_format="pdf_document", output_file="$@")' shellpipes $^
endef

define knitmd
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", md_document(preserve_yaml=TRUE, variant="markdown"), output_file="$@")' shellpipes $^
endef

define knithtml
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", output_format="html_document", output_file="$@")' shellpipes $^
endef

define wrapR
	-$(RM) $@ $@.*
	((R --vanilla --args $@ $^ shellpipes < makestuff/wrappipeR.R > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

run-R = $(wrapR)

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

ifdef alwayspipeR
.PRECIOUS: %.Rout
%.Rout: 
	$(pipeR)
endif

ifdef autopipeRcall
.PRECIOUS: %.Rout
%.Rout: %.R
	$(pipeRcall)
endif

ifdef alwayspipeRcall
.PRECIOUS: %.Rout
%.Rout:
	$(pipeRcall)
endif


ifdef autoknit
%.html: %.Rmd
	$(knithtml)
%.pdf: %.Rmd
	$(knitpdf)
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

.PRECIOUS: %.Rout.tsv
%.Rout.tsv: %.Rout
	$(lscheck)

.PRECIOUS: %.Rout.csv
%.Rout.csv: %.Rout
	$(lscheck)

## ggp.png is more necessary than it should be (pngDesc not working)
## .pdf.tmp is a pure intermediate; you should require .pdf, not .pdf.tmp
%.Rout.pdf.tmp %.Rout.png %.ggp.png %.Rout.jpeg %.ggp.pdf: %.Rout
	$(lscheck)
.PRECIOUS: %.Rout.pdf
%.Rout.pdf: %.Rout
	$(lscheck) || ($(pdfcheck) $@.tmp && $(MVF) $@.tmp $@) || (ls Rplots.pdf && echo WARNING: Trying an orphaned Rplots file && mv Rplots.pdf $@) || (echo ERROR: Failed to find, make or rescue $@ && false)

Ignore += .Rhistory .RData
Ignore += *.RData *.Rlog *.rdata *.rda *.rtmp
Ignore += *.Rout*
Ignore += *.html.args *.pdf.args
Ignore += *.Rds *.rds
Ignore += Rplots.pdf
Ignore += *.ggp.*

######################################################################

## Eval rules for implicit dependencies
## These are necessary so that we can chain through .rda and other products
## but specify dependencies centrally through .Rout

define impdep_r
%.$(1).rda: %.$(1).Rout ; $(lscheck)
%.$(1).rds: %.$(1).Rout ; $(lscheck)
%.$(1).rdata: %.$(1).Rout ; $(lscheck)
%.$(1).rdata: %.$(1).Rout ; $(lscheck)
.PRECIOUS: %.$(1).rdata %.$(1).rda %.$(1).rds %.$(1).Rout 
endef

impmakeR += $(pipeRimplicit)
$(foreach stem,$(impmakeR),$(eval $(call impdep_r,$(stem))))

## Eval rules for "described" pdf files
define pipedesc_r
$(1).%.pdf: $(1).Rout ; $(lscheck)
Ignore += $(1).*.pdf
endef
$(foreach stem,$(pipeRdesc),$(eval $(call pipedesc_r,$(stem))))

## STILL haven't found a reliable description about competing make rules

## Eval rules for "described" pdf files (Rout only)
define pipedesc_rout_r
$(1).%.Rout.pdf: $(1).Rout ; $(lscheck)
Ignore += $(1).*.Rout.pdf
endef
$(foreach stem,$(pipeRoutdesc),$(eval $(call pipedesc_rout_r,$(stem))))

define pngDesc_r
$(1).%.png: $(1).Rout ; $(lscheck)
Ignore += $(1).*.png
endef
$(foreach stem,$(pngDesc),$(eval $(call pngDesc_r,$(stem))))

######################################################################

## Deleting some rules that may be needed for make3?
## See makeR.mk (deleted now)
## Also deleting possibly relevant chain/Makefile
## 2021 Jan 05 (Tue)

######################################################################

## Scripts
## Disentangle how things work, and empower people who don't use make
## Won't work in directories that need non-automatic setup

%.pipeR.script:
	$(MAKE) cpdir.mslink
	$(MAKE) cpdir.localdir
	cd cpdir && $(MAKE) -n $*.Rout > make.log
	perl -wf makestuff/pipeRscript.pl cpdir/make.log > $@

Sources += $(wildcard *.pipeR.script)

