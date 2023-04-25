
Ignore += *.new.tsv *.pgr *.TSV

newtsv = perl -wf makestuff/newtsv.pl $< >  $(hiddentarget) && $(unhidetarget)

%.TSV: %.pgr
	perl -wf makestuff/pgrtsv.pl $< >  $(hiddentarget) && $(unhidetarget)

%.pgr: %.tsv
	perl -wf makestuff/tsvpgr.pl $< >  $(hiddentarget) && $(unhidetarget)

%.tsv.update: %.TSV
	$(MVF) $< $*.tsv

######################################################################

## Is this good??

.PRECIOUS: %.new.tsv
%.new.tsv: %.pgr
	$(newtsv)

%.newtsv: %.new.tsv
	$(MVF) $< $*.tsv
