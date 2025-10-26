## Thinking about pandoc 2 and less-random rules 
## 2019 Feb 12 (Tue)
## Quite a mess here; maybe legacy it and come up with a different name or structure 2020 Feb 15 (Sat)
## Also, having simple default rules, like the first two, conflicts with the idea of sometimes having markdown for notes.

## -S for “smart” quotes
pandocs = pandoc -s -o $@ $<

%.pdf: %.md
	$(pandocs)

%.html: %.md
	$(pandocs)

ghh_r = pandoc -s -f gfm -o $@ $<
%.gh.html: %.md
	$(ghh_r)

Ignore += *.gh.html
%.gh.html: %.mkd
	$(ghh_r)

## Not tested; may cause trouble with mathjax? Just shut up and test it.
Ignore += *.emb.html
%.emb.html: %.md
	pandoc --self-contained -f markdown -o $@ $<

%.doc.md: %.docx
	pandoc -o $@ $<

## Not working on laptop! It inserts a local broken URL instead of cloudflare
## 2023 Feb 28 (Tue) Workaround
JAX = mathjax=https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-AMS_CHTML-full

Ignore += *.jax.html
%.jax.html: %.md.tex
	pandoc $< --$(JAX) -s -o $@

Ignore += *.md.tex
%.md.tex: %.md
	$(pandocs)

## JD LaTeX shorthand
Ignore += *.comb.md
%.comb.md: %.md
	- $(RM) $@
	perl -wf makestuff/texcomb.pl $< > $@
	$(readonly)

%.Rout.html: %.R
	$(rmdhtml)

%.html: %.mkd
	pandoc -s -o $@ $<

%.md.txt: %.md
	pandoc -o $@ $<

%.out: %.md
	pandoc -t plain -o $@ $<

mediawikir = pandoc -f mediawiki -o $@ $<

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

Ignore += *.tex.md
%.tex.md: %.tex
	pandoc -o $@ $<

## Move !includes to the end of document BEFORE md is de-referenced
%.endfloat.MD: %.md makestuff/endfloat.pl
	$(PUSH)

## Move captions above ! includes AFTER md is de-referenced
%.upcap.MD: %.docx.MD makestuff/upcap.pl
	$(PUSH)

######################################################################

## Modular weirdness 2022 Sep 01 (Thu)

lualatex_r = pandoc -o $@ --pdf-engine=lualatex $<
xelex_r = pandoc -o $@ --pdf-engine=xelatex --variable fontsize=12pt $<
ltx_r = pandoc -o $@ --variable fontsize=12pt $<

mdhtml_f = $(subst .md,*.html, $(wildcard *.md))
mdpdf_f = $(subst .md,*.pdf, $(wildcard *.md))

######################################################################

## This is becoming pretty random
%.pan.pdf: %.mkd
	pandoc -o $@ --variable fontsize=12pt $<

%.ltx.pdf: %.md
	$(ltx_r)

%.pan.pdf: %.md
	$(lualatex_r)

rmdpdf = Rscript -e 'library("rmarkdown"); render("$<", output_format="pdf_document")'

knitpdf = Rscript -e 'knitr::knit2pdf("$<")'

rmdpdfBang = Rscript -e 'library("rmarkdown"); render("$<", output_format="pdf_document")'

## Need to make this work with arguments
rmdhtml = Rscript -e 'library("rmarkdown"); render("$<", output_format="html_document", output_file="$@")'

######################################################################
