include $(ms)/perl.def

RRd = $(ms)/wrapR
include $(RRd)/pdf.mk
include $(RRd)/up.mk

## Terrible: use .rmd as intermediate
%.rmd: %.Rmd
	$(copy)

Makefile: $(rdeps)
rscripts = $(wildcard *.R)
rmds = $(wildcard *.rmd)
rdeps = $(rscripts:.R=.rdeps) $(rmds:%=%.rdeps)
-include $(rdeps)

Ignore += $(wildcard *.rdeps)
.PRECIOUS: %.rdeps
%.rdeps: %.R $(ms)/rstep.pl
	$(PUSH)

## For rmd (this rule should be secondary to the one above)
%.rdeps: % $(ms)/rmdstep.pl
	$(PUSH)

Ignore += $(wildcard *.RData *.Rlog *.Rout *.Rout.pdf)
rflags = --no-environ --no-site-file --no-init-file --no-restore
%.Rout: %.R
	$(stepHere)

## Modularize this to make it easier to combine with 
## other directory stuff
define stepHere
	- $(RM) .RData Rplots.pdf $*.RData $*.Rout.pdf 
	( (R $(rflags) --save < $*.R > $@) 2> $*.Rlog && cat $*.Rlog ) || ! cat $*.Rlog
	- $(MV) .RData $*.RData 
	(perl -wf $(RRd)/pdfcheck.pl Rplots.pdf && $(MV) Rplots.pdf $*.Rout.pdf) || :
endef

## 2019 Jul 18 (Thu)
## These seem clunky; maybe the improved stepHere makes them less necessary
stepThere = cd $(dir $<) && Rscript $(notdir $<) > $(notdir $(<:%.R=%.Rout))
plotThere = $(stepThere) && $(MV) Rplots.pdf $(notdir $(<:%.R=%.Rout.pdf))

## Testing: dir does work for ./
## Problem is that we aren't always sure we want to _run_ in other directory
whatever = @echo $(dir $@)
whatever:
	$(whatever)

%.RData: %.Rout ;
%.Rout.pdf: %.Rout
	@ls $@

rclean:
	$(RM) *.Rout *.Rlog *.RData *.rdeps
