include makestuff/perl.def

RRd = makestuff/wrapR
include $(RRd)/pdf.mk
include $(RRd)/up.mk
pdfcheck = $(RRd)/pdfcheck.pl

## Terrible: use .rmd as intermediate
%.rmd: %.Rmd
	$(copy)

Makefile: $(rdeps)
rscripts += $(wildcard *.R)
rmds += $(wildcard *.rmd)
rdeps = $(rscripts:.R=.rdeps) $(rmds:%=%.rdeps)
-include $(rdeps)

Ignore += $(wildcard *.rdeps)
.PRECIOUS: %.rdeps
%.rdeps: %.R makestuff/rstep.pl
	$(PUSH)

## For rmd (this rule should be secondary to the one above)
%.rdeps: % makestuff/rmdstep.pl
	$(PUSH)

Ignore += $(wildcard *.RData *.Rlog *.Rout .*.Rout.pdf *.Rout.pdf *.Rout-*.pdf *.rda)
rflags = --no-environ --no-site-file --no-init-file --no-restore
%.Rout: %.R
	$(stepHere)

## 2019 Sep 11 (Wed)
## For now, _don't do an auto RData; can work on this later (see Extra, below)
define stepHere
	- $(RM) .RData Rplots.pdf $*.RData
	( (R $(rflags) --no-save < $*.R > $(@:%.Rout=%.stepR.rout)) 2> $*.Rlog && cat $*.Rlog ) || ! cat $*.Rlog
	$(MVF) $(@:%.Rout=%.stepR.rout) $@
	- (ls Rplots.pdf && $(MV) Rplots.pdf $*.Rout.pdf) || true
	- $(call hide, $*.Rout.pdf)
endef

## Something about an automatic RData; 
## Deprecated now since we're fixing stepHere 2020 Jun 30 (Tue)
define stepHereExtra
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

## Don't oversimplify! 2020 Jun 30 (Tue)
## %.Rout.pdf: %.Rout ; @ls $@
.PRECIOUS: %.Rout.pdf
%.Rout.pdf: %.Rout
	$(RM) $@
	touch $(call hiddenfile, $@)
	perl -wf $(pdfcheck) $(call hiddenfile, $@)
	$(CP) $(call hiddenfile, $@) $@
	touch $@


rclean:
	$(RM) *.Rout *.Rlog *.RData *.rdeps
