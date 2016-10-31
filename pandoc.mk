%.html: %.md
	pandoc -s -o $@ $<

%.html: %.mkd
	pandoc -s -o $@ $<

%.txt: %.md
	pandoc -o $@ $<

%.out: %.md
	pandoc -t plain -o $@ $<

%.html: %.wikitext
	pandoc -f mediawiki -o $@ $<

%.html: %.csv
	csv2html -o $@ $<

%.html: %.rmd
	Rscript -e "library(\"rmarkdown\"); render(\"$<\")"

%.md: %.rmd
	Rscript -e "library(\"knitr\"); knit(\"$<\")"

%.tex: %.md
	pandoc -s -S -t latex -V documentclass=tufte-handout $*.md -o $*.tex

