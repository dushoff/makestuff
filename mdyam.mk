## Treat up to the first blank line as yaml
Ignore += *.rym *.rwm
rym_r = perl -nE "last if /^$$/; print; END{say}" $< > $*.rym
rwm_r = Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$*.rwm")' $^

define rmk_r
	$(rym_r)
	$(rwm_r)
	$(CAT) $*.rym $*.rwm > $@
	$(RM) $*.rym $*.rwm
endef

Ignore += *.rmk
%.rmk: %.rmd
	$(rmk_r)

## Deprecate this; maybe change them to rmd and manually invoke dmd_r somehow
## rmd is now made from dmd; don't let both be sources 2021 Sep 15 (Wed) 
%.rmd: %.dmd
	$(dmd_r)
	$(copy)
