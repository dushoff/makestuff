
## .def??

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

## .mk??
## Started in haste 2019 Sep 01 (Sun)

## This rule should FILTER. 
mds_r = pandoc --mathjax -s -c main.css -B main.header.html -A main.footer.html -o $@ $<

## Source ⇒ product

pages/%.html: %.mkd main.css main.header.html main.footer.html
	$(mds_r)

ship_pages:
	cd pages && ! git commit -am "Orphan commit!"
	cd pages && git pull || ( echo "WAIT: Don't ship_pages until you can pull" && false)
	$(MAKE) $(pageProducts)

push_all: ship_pages
	cd pages && git add $(pageProductsLocal) && git pull && git push

all.time: push_all
