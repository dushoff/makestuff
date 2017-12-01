## -S is “smart”
%.html: %.md
	pandoc -s -S -o $@ $<

## Not tested; may cause trouble with mathjax? Just shut up and test it.
%.emb.html: %.md
	pandoc --self-contained -S -o $@ $<

%.html: %.mkd
	pandoc -s -o $@ $<

%.md.txt: %.md
	pandoc -o $@ $<

%.out: %.md
	pandoc -t plain -o $@ $<

%.html: %.wikitext
	pandoc -f mediawiki -o $@ $<

%.html: %.csv
	csv2html -o $@ $<

%.html: %.rmd
	Rscript -e "library(\"rmarkdown\"); render(\"$<\")"

%.tex: %.Rnw
	Rscript -e "library(\"knitr\"); knit(\"$<\")"

%.md: %.rmd
	Rscript -e "library(\"knitr\"); knit(\"$<\")"

%.th.tex: %.md
	pandoc -s -S -t latex -V documentclass=tufte-handout $*.md -o $*.tex

%.md: %.tex
	pandoc -o $@ $<

## This is becoming pretty random
%.pdf: %.mkd
	pandoc -o $@ --variable fontsize=12pt $<

