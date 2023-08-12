
Ignore += *.new.tsv *.pgr *.TSV

newtsv = perl -wf makestuff/newtsv.pl $< >  $(hiddentarget) && $(unhidetarget)

%.TSV: %.pgr
	perl -wf makestuff/pgrtsv.pl $< >  $(hiddentarget) && $(unhidetarget)

%.pgr: %.tsv
	perl -wf makestuff/tsvpgr.pl $< >  $(hiddentarget) && $(unhidetarget)

%.header.pgr: %.pgr makestuff/pgrHead.pl
	$(PUSH)

%.pgr.addhead: %.header.pgr
	$(CP) $< $*.pgr

%.tsv.update: %.TSV
	$(MVF) $< $*.tsv

## Auto update tsv if pgr exists!
pgr_files = $(wildcard *.pgr)
pgr_stems = $(pgr_files:%.pgr=%)
tsv_files = $(wildcard *.tsv)
tsv_stems = $(tsv_files:%.tsv=%)
tsv_pgr = $(filter $(tsv_stems), $(pgr_stems))
tsv_updates = $(tsv_pgr:%=%.tsv.update)
tsv_updates: $(tsv_updates) ;

######################################################################

## Is this good??

.PRECIOUS: %.new.tsv
%.new.tsv: %.pgr
	$(newtsv)

%.newtsv: %.new.tsv
	$(MVF) $< $*.tsv
