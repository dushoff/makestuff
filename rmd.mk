## Hacking away for Sylvie 2019 Sep 12 (Thu)
## Focus on recipes for now (should do that more)

## rmarkdown conversion
## auto-dependency stuff could go into a trickier place
## see also stepR and its rmd stuff.

## Basically, it only seems to work to make render outputs in the file directory
rmdmd_r = Rscript --vanilla -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$@")'

rmdh_r = Rscript --vanilla -e 'library("rmarkdown"); render("$<", output_format="html_document", output_file="$(notdir $@)", output_dir="$(dir $@)")'

## Used to be rmdh_p because I was not parsing correctly
rmdp_r = Rscript --vanilla -e 'library("rmarkdown"); render("$<", output_format="pdf_document", output_file="$(notdir $@)", output_dir="$(dir $@)")'

tangle_r = Rscript --vanilla -e 'library("knitr"); knit("$<", output="$@", tangle=TRUE)'

## Use small r here to avoid accidental commits?
%.tangle.r: %.Rmd
	$(tangle_r)

%.tangle.r: %.rmd
	$(tangle_r)

## Use weird extensions for default rules in case we want to make fancy rules for normal extension?

## This also allows a single rule for Rmd/rmd !
Ignore += *md.html
%md.html: %md
	$(rmdh_r)
