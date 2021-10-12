## Thinking about pandoc 2 and less-random rules 
## 2019 Feb 12 (Tue)
## Quite a mess here; maybe legacy it and come up with a different name or structure 2020 Feb 15 (Sat)

## -S for “smart” quotes
pandocs = pandoc -s -o $@ $<

%.html: %.md
	$(pandocs)

ghh_r = pandoc -s -f gfm -o $@ $<
%.gh.html: %.md
	$(ghh_r)

%.gh.html: %.mkd
	$(ghh_r)

## Not tested; may cause trouble with mathjax? Just shut up and test it.
%.emb.html: %.md
	pandoc --self-contained -S -o $@ $<

%.doc.md: %.docx
	pandoc -o $@ $<

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

rmdh = Rscript -e "library(\"rmarkdown\"); render(\"$<\")"
%.html: %.Rmd
	$(rmdh)

%.html: %.rmd
	$(rmdh)

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

%.tex.md: %.tex
	pandoc -o $@ $<

## Move captions above ! includes
%.upcap.md: %.docx.md makestuff/upcap.pl
	$(PUSH)
  
## This is becoming pretty random
%.pan.pdf: %.mkd
	pandoc -o $@ --variable fontsize=12pt $<

%.ltx.pdf: %.md
	pandoc -o $@ --variable fontsize=12pt $<

%.pan.pdf: %.md
	pandoc -o $@ --pdf-engine=lualatex --variable fontsize=12pt $<

rmdpdf = Rscript -e 'library("rmarkdown"); render("$<", output_format="pdf_document")'

knitpdf = Rscript -e 'knitr::knit2pdf("$<")'

rmdpdfBang = Rscript -e 'library("rmarkdown"); render("$<", output_format="pdf_document")'

######################################################################
