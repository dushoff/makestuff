## Thinking about pandoc 2 and less-random rules 
## 2019 Feb 12 (Tue)

## -S for “smart” quotes (those quotes were a failed message to myself)
%.html: %.md
	pandoc -s -o $@ $<

ghh_r = pandoc -s -f gfm -o $@ $<
%.gh.html: %.md
	$(ghh_r)

%.gh.html: %.mkd
	$(ghh_r)


## Not tested; may cause trouble with mathjax? Just shut up and test it.
%.emb.html: %.md
	pandoc --self-contained -S -o $@ $<

Ignore += *.jax.html
%.jax.html: %.md
	pandoc --mathjax -s -o $@ $<

%.html: %.mkd
	pandoc -s -o $@ $<

%.md.txt: %.md
	pandoc -o $@ $<

%.out: %.md
	pandoc -t plain -o $@ $<

%.html: %.wikitext
	pandoc -f mediawiki -o $@ $<

%.md: %.wikitext
	pandoc -f mediawiki -o $@ $<

%.html: %.csv
	csv2html -o $@ $<

%.html: %.Rmd
	Rscript -e "library(\"rmarkdown\"); render(\"$<\")"

%.html: %.rmd
	Rscript -e "library(\"rmarkdown\"); render(\"$<\")"

.PRECIOUS: %.tex
%.tex: %.Rnw
	Rscript -e "library(\"knitr\"); knit(\"$<\")"

## Old and busted
%-knitr.Rnw: %.Rnw
	Rscript -e "library(\"knitr\"); Sweave2knitr(\"nn_presentation.Rnw\")"

%.md: %.rmd
	Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document")'

%.knit.md: %.rmd
	Rscript -e "library(\"knitr\"); knit(\"$<\")"

%.th.tex: %.md
	pandoc -s -S -t latex -V documentclass=tufte-handout $*.md -o $*.tex

%.md: %.tex
	pandoc -o $@ $<

## This is becoming pretty random
%.pdf: %.mkd
	pandoc -o $@ --variable fontsize=12pt $<

%.pdf: %.md
	pandoc -o $@ --pdf-engine=lualatex --variable fontsize=12pt $<

rmdpdf = Rscript -e 'library("rmarkdown"); render("$<", output_format="pdf_document")'

rmdpdfBang = Rscript -e 'library("rmarkdown"); render("$<", output_format="pdf_document")'
