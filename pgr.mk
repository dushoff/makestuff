
Ignore += *.new.tsv *.pgr *.TSV

newtsv = perl -wf makestuff/newtsv.pl $< > $@

%.TSV: %.pgr
	perl -wf makestuff/pgrtsv.pl $< > $@

%.pgr: %.tsv
	perl -wf makestuff/tsvpgr.pl $< > $@

.PRECIOUS: %.new.tsv
%.new.tsv: %.pgr
	$(newtsv)

%.newtsv: %.new.tsv
	$(MVF) $< $*.tsv

%.tsv.update: %.TSV
	$(MVF) $< $*.tsv

