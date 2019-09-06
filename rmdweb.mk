
## Definitions

## 2019 Sep 05 (Thu)
## All this redundancy could presumably be avoided, but only 
## by learning more than I know about string manipulation
mkd = $(wildcard *.mkd)
Rmd = $(wildcard *.Rmd)
rmd = $(wildcard *.rmd)

lmkd = $(wildcard *.lect.mkd)
lRmd = $(wildcard *.lect.Rmd)
lrmd = $(wildcard *.lect.rmd)

## pageSources already include lectSources, so the latter is not a thing
pageSources += $(mkd) $(Rmd) $(rmd)

pageProductsLocal += $(mkd:.mkd=.html)
pageProductsLocal += $(Rmd:.Rmd=.html)
pageProductsLocal += $(rmd:.rmd=.html)
pageProductsLocal += $(mkd:.mkd=.html)
pageProductsLocal += $(lmkd:.lect.mkd=.io.html)
pageProductsLocal += $(lRmd:.lect.Rmd=.io.html)
pageProductsLocal += $(lrmd:.lect.rmd=.io.html)

pageProducts = $(pageProductsLocal:%=pages/%)

Sources += $(pageSources)

## Recipes

## This rule should filter filenames instead of specifying "main". 
mdh_r = pandoc --mathjax -s -c main.css -B main.header.html -A main.footer.html -o $@ $<

## Source ⇒ product
pages/%.html: %.mkd main.css main.header.html main.footer.html
	$(mdh_r)
pages/%.html: %.rmk main.css main.header.html main.footer.html
	$(mdh_r)
pages/%.notes.html: %.mkd main.css main.header.html main.footer.html
	$(mdh_r)
pages/%.notes.html: %.rmk main.css main.header.html main.footer.html
	$(mdh_r)

## In some haste now.
## pages/intro.io.html:
mdio_r = echo 'rmarkdown::render("$<",output_format="ioslides_presentation", output_file="$(notdir $@)", output_dir="$(dir $@)")' | R --vanilla

pages/%.io.html: %.lect.mkd
	$(mdio_r)
pages/%.io.html: %.lect.rmk
	$(mdio_r)

## rmd. This is awkward because rmarkdown library does not play well with piping
## At some point could add rmdstep-ish stuff here (automatic dependencies)
rwm_r = Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$@")'
Ignore += *.rwm
%.rwm: %.rmd
	$(rwm_r)
%.rwm: %.Rmd
	$(rwm_r)

## Treat up to the first blank line as yaml
Ignore += *.rym
rym_r = perl -nE "last if /^$$/; print; END{say}" $< > $@
%.rym: %.rmd
	$(rym_r)
%.rym: %.Rmd
	$(rym_r)

Ignore += *.rmk
%.rmk: %.rym %.rwm
	$(cat)

## Outputting

#### If we do the simple pull early, does that lead to less making on the pages side?
pull_all: makestuff.pull pull pull_pages
pullup: pull pull_pages

## Not so clear what the Orphans are about or whether they should break us

pull_pages:
	- cd pages && ! git commit -am "Orphan commit!"
	cd pages && git pull

ship_pages:
	$(MAKE) pull_pages || ( echo "WAIT: Don't ship_pages until you can pull" && false)
	$(MAKE) $(pageProducts)

local_index: ship_pages pages/index.html.go

push_pages: ship_pages
	cd pages && git add $(pageProductsLocal) && git pull && git push

push_all: up.time push_pages

%.direct: %
	$(CP) $< pages/
	$(MAKE) $<.pages
