## Treat up to the first blank line as yaml
Ignore += *.rym *.rwm
rym_r = perl -nE "last if /^$$/; print; END{say}" $< > $*.rym
rwm_r = Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$*.rwm")' $^

## Works with dmdeps.mk; bad form to let dmd and rmd compete
Ignore += *.rmk
%.rmk: %.dmd
	$(dmd)
	$(rym_r)
	$(rwm_r)
	$(CAT) $*.rym $*.rwm > $@
	$(RM) $*.rym $*.rwm

## Eventually want to make slides from rmk, but it's not working prettily now, so we need this parallel track
%.rmd: %.dmd
	$(dmd)
	$(copy)
