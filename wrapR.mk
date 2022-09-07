## Deprecated; see makestuff/pipeR.mk
wrapRd = makestuff/wrapR
RRd = makestuff/wrapR
include $(RRd)/pdf.mk
include $(RRd)/up.mk

wrapR = $(wrapRd)/wrapper.pl
Rtrim = $(RRd)/Rtrim.pl
pdfcheck = $(RRd)/pdfcheck.pl

define run-R 
	perl -f $(wrapR) $@ $^ > $(@:.Rout=.wrapR.r)
	( (R --vanilla < $(@:.Rout=.wrapR.r) > $(@:%.Rout=%.wrapR.rout)) 2> $(@:%.Rout=%.Rlog) && cat $(@:%.Rout=%.Rlog) ) || ! cat $(@:%.Rout=%.Rlog)
	$(RM) $@.pdf
	perl -wf $(Rtrim) $(@:%.Rout=%.wrapR.rout) > $@
	$(call hide,  $(@:%.Rout=%.Rlog))
	$(call hide,  $(@:%.Rout=%.wrapR.rout))
endef

.PRECIOUS: %.Rlib.R
%.Rlib.R: makestuff/
	echo 'library("$*")' > $@

.PRECIOUS: %.summary.Rout
%.summary.Rout: %.Rout $(RRd)/summary.R
	$(run-R)

.PRECIOUS: %.objects.Rout
%.objects.Rout: %.Rout $(RRd)/objects.R
	$(run-R)

ifndef disable_automatic_wrapR
.PRECIOUS: %.Rout
%.Rout: %.R
	$(run-R)
endif

.PRECIOUS: %.wrapR.r
%.wrapR.r: %.Rout ;

.PRECIOUS: %.Rout.csv
%.Rout.csv: %.Rout ;

.PRECIOUS: %.Rout.pdf
%.Rout.pdf: %.Rout
	$(RM) $@
	touch $(call hiddenfile, $@)
	perl -wf $(pdfcheck) $(call hiddenfile, $@)
	$(CP) $(call hiddenfile, $@) $@
	touch $@

## Should this just be unhide? No, that moves not copies.
%.RData: %.Rout
	$(CP) $(call hiddenfile, $@) $@

%.Rout.png: %.Rout.pdf
	/bin/rm -f $@
	convert $<[0] $@ || gm convert $< $@

%.Routput: %.Rout
	perl -f $(RRd)/Rcalc.pl $< > $@ 

.PRECIOUS: %.Rds
%.Rds: %.Rout
	$(CP) $(call hiddenfile, $@) $@

.PRECIOUS: .%.RData
.%.RData: %.Rout ;

rcopy = $(copy); $(CP) $(<:%.Rout=.%.RData) $(@:%.Rout=.%.RData)

rclean:
	$(RM) *.Rout

# Why doesn't this seem to chain?
# Make implicit-rule recursion seems poorly documented; try to make a toy example. For now, put stepping stones in the Makefile.
.PRECIOUS: %.envir
%.envir: %
	touch $@

Ignore += *.RData *.Rlog .Rhistory *.Rout* *.wrapR.* *.Rds

## Added 2022 May 31 (Tue); why was this not a problem before?
Ignore += *.rda *.rds
