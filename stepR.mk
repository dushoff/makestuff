include $(ms)/perl.def
stepRd = $(ms)/stepR
RRd = $(ms)/RR
include $(RRd)/pdf.mk
include $(RRd)/up.mk

rflags = --no-environ --no-site-file --no-init-file --no-restore
%.Rout: %.R /proc/uptime
	$(MAKE) -f $(ms)/deps.mk -f Makefile $*.reqs
	( (R $(rflags) --save < $< > $@) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog) ) || ! cat $(@:%.Rout=%.Rlog)
	$(MV) .RData $*.RData

%.reqs: %.deps
	-$(MAKE) -f $< -f Makefile $@

.PRECIOUS: %.deps
%.deps: %.R $(ms)/rstep.pl
	$(PUSH)
