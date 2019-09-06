
## Ukucathula

tangle_r = Rscript -e 'library("knitr"); knit("$<", output="$@", tangle=TRUE)'
%.tangle.R: %.Rmd
	$(tangle_r)

