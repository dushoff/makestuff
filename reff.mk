## This whole file seems to be in a random-ish order; not sure how much this matters

## TEMPORARY recipe
Ignore += reff
.PRECIOUS: reff/%
reff/%: | reff
	$(CP) ~/screens/org/nsercMixing/$* $@
	
reff: | makestuff
	$(LN) makestuff/$@ .

%.pmlist: %.pmsearch reff/pm.py
	$(PITH)

Sources += $(wildcard bibdir/*.corr)
Ignore += $(wildcard bibdir/*.rec)
bibdir/%: | bibdir
bibdir:
	$(mkdir)
## If we change a correction file we need to remake any .recs file
$(wildcard *.recs): $(wildcard bibdir/*.corr)

Sources += *.rmu
Ignore += *.reff.bib *.recs
%.recs: %.rmu reff/rmu.py
	$(PITH)

Ignore += *.gfm
%.gfm: %.reff.MD reff/MDgfm.pl %.downloads
	$(PUSH)

Ignore += *.reff.html
%.reff.html: %.gfm
	pandoc -f gfm -t html $< > $@

Ignore += *.downloads unfetched_pmcids.tsv
%.downloads: %.tags.pgr library reff/download.py | doi2pdf.pip metapub.pip pubmed-pdf-downloader.pip
	$(PITH)

Ignore += *.reff.pgr
%.reff.pgr: %.recs reff/recspgr.pl
	$(PUSHRO)

Ignore += *.tags.pgr
%.tags.pgr: %.reff.pgr reff/tags.pl
	$(PUSHRO)

Ignore += *.reff.MD
%.reff.MD: %.tags.pgr reff/pgrMD.pl
	$(PUSHRO)

%.bib: %.tags.pgr reff/pgrbib.pl
	$(PUSHRO)

Ignore += library
library:
	$(mkdir)


