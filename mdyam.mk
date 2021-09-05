## Treat up to the first blank line as yaml
Ignore += *.rym *.rwm
rym_r = perl -nE "last if /^$$/; print; END{say}" $< > $*.rym
rwm_r = Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$*.rwm")' $^

Ignore += *.rmk
%.rmk: %.rmd
	$(rym_r)
	$(rwm_r)
	$(CAT) $*.rym $*.rwm > $@
	$(RM) $*.rym $*.rwm

