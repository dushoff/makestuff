## Contributed by David Earn
%.html: %.md
	Rscript -e "rmarkdown::render(\"$<\")"
