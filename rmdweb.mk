
## Definitions

## 2019 Sep 05 (Thu)
## All this redundancy could presumably be avoided, but only 
## by learning more than I know about string manipulation
mkd = $(wildcard *.mkd)
rmd = $(wildcard *.rmd)

lmkd = $(wildcard *.lect.mkd)
lrmd = $(wildcard *.lect.rmd)

## pageSources already include lectSources, so the latter is not a thing
pageSources += $(mkd) $(rmd)

pageProductsLocal += $(mkd:.mkd=.html)
pageProductsLocal += $(rmd:.rmd=.html)
pageProductsLocal += $(mkd:.mkd=.html)
pageProductsLocal += $(lmkd:.lect.mkd=.io.html)
pageProductsLocal += $(lrmd:.lect.rmd=.io.html)

## _files refers to rmd _files/ directories here
page_files = $(local_files:%=pages/%)

## Probably unnecessary
local_files = $(wildcard *_files/*)
pageProductsLocal += $(local_files)

pageProducts = $(pageProductsLocal:%=pages/%)

Sources += $(pageSources)

## Recipes

tangle_r = Rscript -e 'library("knitr"); knit("$<", output="$@", tangle=TRUE)'

## This rule should filter filenames instead of specifying "main". 
## Fiddling with knitr arguments
mdh_r = pandoc --filter pandoc-citeproc --to html4 --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash+smart --mathjax -s -c main.css -B main.header.html -A main.footer.html -o $(notdir $@) $<; $(MV) $(notdir $@) $(dir $@)
rmdfiles_r = $(CPR) $*_files $(dir $@)

## Source ⇒ product
## rmdfiles_r is probably unnecessary!
pages/%.html: %.mkd main.css main.header.html main.footer.html
	$(mdh_r)
	- $(rmdfiles_r)
pages/%.html: %.rmk main.css main.header.html main.footer.html %.rmd
	$(mdh_r)
	- $(rmdfiles_r)
pages/%.notes.html: %.mkd main.css main.header.html main.footer.html
	$(mdh_r)
pages/%.notes.html: %.rmk main.css main.header.html main.footer.html %.rmd
	$(mdh_r)

## page_files are made as side effects of compilation from rmd. We hope
$(page_files): ;

Ignore += $(wildcard *_cache)/*
Ignore += $(wildcard *_files)/*

## In some haste now.
## pages/intro.io.html:
mdio_r = echo 'rmarkdown::render("$<",output_format="ioslides_presentation", output_file="$(notdir $@)", output_dir="$(dir $@)")' | R --vanilla

pages/%.io.html: %.lect.mkd
	$(mdio_r)

## Choose one pipeline; former is more parallel, latter works better up until now.
## pages/%.io.html: %.lect.rmk; $(mdio_r)
## pages/%.io.html: %.lect.rmd; $(mdio_r)

## rmd. This is awkward because rmarkdown library does not play well with piping
## At some point could add rmdstep-ish stuff here (automatic dependencies)
rwm_r = Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$@")'
Ignore += *.rwm
%.rwm: %.rmd
	$(rwm_r)

## 2019 Nov 08 (Fri)
## Not sure why there's so much remaking; something about this gap?
## Make it all one step?
## Treat up to the first blank line as yaml
Ignore += *.rym
rym_r = perl -nE "last if /^$$/; print; END{say}" $< > $@
%.rym: %.rmd
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

push_pages: ship_pages sync_pages

sync_pages:
	cd pages && git add $(pageProductsLocal)
	- cd pages && git commit -am "Autosync"
	cd pages && git pull && git push

push_all: up.time push_pages
