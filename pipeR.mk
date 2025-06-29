pdfcheck = perl -wf makestuff/wrapR/pdfcheck.pl

rvan = R --vanilla
noMakeFlags = env -u MAKELEVEL -u MAKEFLAGS
stanVan = $(noMakeFlags) $(rvan)
rrun ?= $(rvan)

define makeArgs
	@echo "rpcall(\"$@ $*.pipestar $^\")"  >> $@.args
	@echo >> $@.args
endef

## Potential infelicity if a script used to produce a file
## but now runs successfully without producing it
## file can still be used downstream
## awkwardly delete known target types; or make all known targets start with full target name?
define pipeR
	@-$(RM) $@ $@.*
	@$(makeArgs)
	@echo pipeR: Making $@ using $^
	@(($(rrun) --args $@ shellpipes $*.pipestar $^ < $(word 1, $(filter %.R, $^)) > $@) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (sleep 1 && touch $(word 1, $(filter %.R, $^)) && cat $(@:%.Rout=%.Rlog) && false)
endef

## Make the rpcall first so that we don't outdate things
define pipeRcall
	perl -wf makestuff/pipeRcall.pl $@ $^
	$(pipeR)
endef

## Back-compatility
makeR=$(pipeR)

## This stuff should be refactored, and also reconciled with a _bunch_ of other stuff:
## rmd, rmdweb, pandoc ...
define render
	-$(RM) $@ $@.*
	$(makeArgs)
	$(rrun) -e 'library("rmarkdown"); render("$<", output_file="$@")' shellpipes $*.pipestar $^
endef

define render_rmd
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript --vanilla -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", output_file="$@")' shellpipes $*.pipestar $^
endef

define knitpdf
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript --vanilla -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", output_format="pdf_document", output_file="$@")' shellpipes $*.pipestar $^
endef

define knitmd
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript --vanilla -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", md_document(preserve_yaml=TRUE, variant="markdown"), output_file="$@")' shellpipes $*.pipestar $^
endef

define knithtml
	-$(RM) $@ $@.*
	$(makeArgs)
	Rscript --vanilla -e 'library("rmarkdown"); render("$(word 1, $(filter %.rmd %.Rmd, $^))", output_format="html_document", output_file="$@")' shellpipes $*.pipestar $^
endef

define wrapR
	-$(RM) $@ $@.*
	(($(rrun) --args $@ $^ shellpipes < makestuff/wrappipeR.R > $(@:%.Rout=%.rtmp)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog)) || (cat $(@:%.Rout=%.Rlog) && false)
	$(MVF) $(@:%.Rout=%.rtmp) $@
endef

run-R = $(wrapR)

define scriptR
	cd $(dir $<) && $(rrun) < $(notdir $<) > $(notdir $@)
endef

## Legacy
ifdef autowrapR
.PRECIOUS: %.Rout
%.Rout: %.R
	$(wrapR)
endif

## autopipeR seems like a reasonable default
ifdef autopipeR
.PRECIOUS: %.Rout
%.Rout: %.R
	$(pipeR)
endif

## More aggressive autopiping
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

%.Routput: %.Rout
	perl -f makestuff/wrapR/Rcalc.pl $< > $@ 

######################################################################

ifdef autoknit
%.html: %.rmd
	$(knithtml)
%.html: %.Rmd
	$(knithtml)
%.pdf: %.rmd
	$(knitpdf)
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
	$(lstouch)

.PRECIOUS: %.rds %.Rds
%.rds %.Rds: %.Rout
	$(lstouch)

.PRECIOUS: %.Rout.tsv
%.Rout.tsv: %.Rout
	$(lstouch)

.PRECIOUS: %.Rout.csv
%.Rout.csv: %.Rout
	$(lstouch)

## ggp.png is more necessary than it should be (pngDesc not working)
## .pdf.tmp is a pure intermediate; you should require .pdf, not .pdf.tmp
%.Rout.pdf.tmp %.Rout.png %.ggp.png %.Rout.jpeg %.ggp.pdf %.Rout.tikz: %.Rout
	$(lstouch)
.PRECIOUS: %.Rout.pdf
%.Rout.pdf: %.Rout
	$(lstouch) || (ls $@.tmp && $(pdfcheck) $@.tmp && $(MVF) $@.tmp $@) || (ls Rplots.pdf && echo "WARNING: Using an orphaned Rplots file; maybe try startGraphics()" && mv Rplots.pdf $@) || (echo ERROR: Failed to find, make or rescue $@ && false)

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
%.$(1).rda: %.$(1).Rout ; $(impcheck)
%.$(1).rds: %.$(1).Rout ; $(impcheck)
%.$(1).rdata: %.$(1).Rout ; $(impcheck)
%.$(1).Rdata: %.$(1).Rout ; $(impcheck)
.PRECIOUS: %.$(1).Rdata %.$(1).rdata %.$(1).rda %.$(1).rds %.$(1).Rout 
endef

impmakeR += $(pipeRimplicit)
$(foreach stem,$(impmakeR),$(eval $(call impdep_r,$(stem))))

## Eval rules for "described" pdf files
define pipedesc_r
$(1).%.pdf: $(1).Rout ; $(impcheck)
Ignore += $(1).*.pdf
endef

## Why do I have both of these variables?
pipeRdesc += $(pdfDesc)
$(foreach stem,$(pipeRdesc),$(eval $(call pipedesc_r,$(stem))))

## STILL haven't found a reliable description about competing make rules

## Eval rules for "described" pdf files (Rout only)
define pipedesc_rout_r
$(1).%.Rout.pdf: $(1).Rout ; $(impcheck)
Ignore += $(1).*.Rout.pdf
endef
$(foreach stem,$(pipeRoutdesc),$(eval $(call pipedesc_rout_r,$(stem))))

define pngDesc_r
$(1).%.png: $(1).Rout ; $(impcheck)
Ignore += $(1).*.png
endef
$(foreach stem,$(pngDesc),$(eval $(call pngDesc_r,$(stem))))

######################################################################

## Scripts
## Disentangle how things work, and empower people who don't use make
## Won't work in directories that need non-automatic setup

%.pipeR.script:
	$(MAKE) dotdir.mslink
	$(MAKE) dotdir.localdir
	$(MAKE) dotdir.testsetup
	cd dotdir && $(MAKE) -n $*.Rout > make.log
	perl -wf makestuff/pipeRscript.pl dotdir/make.log > $@

Ignore += $(wildcard *.pipeR.script)

%.Rscript: %.pipeR.script makestuff/allR.pl
	$(PUSH)

Ignore += $(wildcard *.allR)
%.allR: %.Rscript
	$(rrun)  < $< | tee $@

######################################################################

## Legacy cleaning

wrapclean wrapClean:
	rm -fr *.wrapR* .*.wrapR*

pipeclean pipeClean:
	rm -fr *.Rout *.Rout.* *.rda *.rds 
