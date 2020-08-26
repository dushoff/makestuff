## Hacking away for Sylvie 2019 Sep 12 (Thu)
## Focus on recipes for now (should do that more)

## rmarkdown conversion
## auto-dependency stuff could go into a trickier place
## see also stepR and its rmd stuff.

rmdmd_r = Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$@")'

rmdh_r = Rscript -e 'library("rmarkdown"); render("$<", output_format="html_document", output_file="$@")'

tangle_r = Rscript -e 'library("knitr"); knit("$<", output="$@", tangle=TRUE)'

## Use small r here to avoid accidental commits?
%.tangle.r: %.Rmd
	$(tangle_r)

## Use weird extensions for default rules in case we want to make fancy rules for normal extension?

## This also allows a single rule for Rmd/rmd !
Ignore += *md.html
%md.html: %md
	$(rmdh_r)
