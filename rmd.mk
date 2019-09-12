## Hacking away for Sylvie 2019 Sep 12 (Thu)
## Just recipes for now (should do that more)

## rmarkdown conversion
## auto-dependency stuff could go into a trickier place
## see also stepR and its rmd stuff.
rwm_r = Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$@")'
