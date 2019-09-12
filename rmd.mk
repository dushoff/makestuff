
## Hacking away for Sylvie 2019 Sep 12 (Thu)
## Just recipes for now (should do that more)

## rmarkdown conversion
## auto-dependency stuff could go into a trickier place
## see also stepR and its rmd stuff.
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
