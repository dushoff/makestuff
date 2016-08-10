wrapRd = $(ms)/wrapR
RRd = $(ms)/RR
include $(RRd)/pdf.mk
include $(RRd)/up.mk

wrapR = $(wrapRd)/wrapper.pl
Rtrim = $(RRd)/Rtrim.pl
pdfcheck = $(RRd)/pdfcheck.pl

define run-R 
	perl -f $(wrapR) $@ $^ > $(@:.Rout=.wrapR.r)
	( (R --vanilla < $(@:.Rout=.wrapR.r) > $(@:%.Rout=%.wrapR.rout)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog) ) || ! cat $(@:%.Rout=%.Rlog)
	perl -wf $(Rtrim) $(@:%.Rout=%.wrapR.rout) > $@
	$(call hide,  $(@:%.Rout=%.Rlog))
	$(call hide,  $(@:%.Rout=%.wrapR.rout))
endef

.PRECIOUS: %.Rlib.R
%.Rlib.R: $(ms)/
	echo 'library("$*")' > $@

.PRECIOUS: %.summary.Rout
%.summary.Rout: %.Rout $(RRd)/summary.R
	$(run-R)

.PRECIOUS: %.objects.Rout
%.objects.Rout: %.Rout $(RRd)/objects.R
	$(run-R)

.PRECIOUS: %.Rout
%.Rout: %.R
	$(run-R)

.PRECIOUS: %.wrapR.r
%.wrapR.r: %.Rout ;

.PRECIOUS: %.Rout.csv
%.Rout.csv: %.Rout ;

.PRECIOUS: %.Rout.pdf
%.Rout.pdf: %.Rout
	$(RM) $@
	touch .$@
	perl -wf $(pdfcheck) .$@
	$(LN) .$@ $@
	touch $@

%.Rout.png: %.Rout.pdf
	/bin/rm -f $@
	convert $<[0] $@

%.Routput: %.Rout
	perl -f $(RRd)/Rcalc.pl $< > $@ 

.PRECIOUS: %.Rds
%.Rds: %.Rout ;

.PRECIOUS: .%.RData
.%.RData: %.Rout ;

# Why doesn't this seem to chain?
# Make implicit-rule recursion seems poorly documented; try to make a toy example. For now, put stepping stones in the Makefile.
.PRECIOUS: %.envir
%.envir: %
	touch $@
