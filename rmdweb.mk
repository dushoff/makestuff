
## Definitions

mkd = $(wildcard *.mkd)
Rmd = $(wildcard *.Rmd)
rmd = $(wildcard *.rmd)

pageSources += $(mkd) $(Rmd) $(rmd)

pageProductsLocal += $(mkd:.mkd=.html)
pageProductsLocal += $(Rmd:.Rmd=.html)
pageProductsLocal += $(rmd:.rmd=.html)
pageProductsLocal += main.css

pageProducts = $(pageProductsLocal:%=pages/%)

Sources += $(pageSources)

## Recipes

## This rule should FILTER. 
mds_r = pandoc --mathjax -s -c main.css -B main.header.html -A main.footer.html -o $@ $<

## Source ⇒ product

pages/%.html: %.mkd main.css main.header.html main.footer.html
	$(mds_r)

pages/%.html: %.rmk main.css main.header.html main.footer.html
	$(mds_r)

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

pull_all: pull_pages pull makestuff.pull
pullup: pull_pages

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
