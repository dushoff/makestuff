include $(ms)/perl.def

RRd = $(ms)/RR
include $(RRd)/pdf.mk
include $(RRd)/up.mk

-include $(wildcard .*.rdeps)

.PRECIOUS: %.rdeps
%.rdeps: %.R $(ms)/rstep.pl
	$(PUSH)
	$(CP) $@ .$@

rflags = --no-environ --no-site-file --no-init-file --no-restore
%.Rout: %.rdeps
	$(MAKE) $*.rdeps
	( (R $(rflags) --save < $*.R > $@) 2> $*.Rlog && cat $*.Rlog ) || ! cat $*.Rlog
	- $(MV) .RData $*.RData

%.RData: %.Rout ;

rclean:
	$(RM) *.Rout *.Rlog *.RData *.rdeps
