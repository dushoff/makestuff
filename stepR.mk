include $(ms)/perl.def

RRd = $(ms)/wrapR
include $(RRd)/pdf.mk
include $(RRd)/up.mk

rscripts = $(wildcard *.R)
rdeps = $(rscripts:.R=.rdeps)
-include $(wildcard *.rdeps)
Makefile: $(rdeps)

Ignore += $(wildcard *.rdeps)
.PRECIOUS: %.rdeps
%.rdeps: %.R $(ms)/rstep.pl
	$(PUSH)

Ignore += $(wildcard *.RData *.Rlog *.Rout)
rflags = --no-environ --no-site-file --no-init-file --no-restore
%.Rout: %.R
	- $(RM) .RData
	( (R $(rflags) --save < $*.R > $@) 2> $*.Rlog && cat $*.Rlog ) || ! cat $*.Rlog
	- $(MV) .RData $*.RData

%.RData: %.Rout ;

rclean:
	$(RM) *.Rout *.Rlog *.RData *.rdeps
