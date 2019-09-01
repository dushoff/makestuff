
## Developing at the same time as 20190744; need to revisit

## This rule should FILTER. 
mds_r = pandoc --mathjax -s -c main.css -B main.header.html -A main.footer.html -o $@ $<

## Source ⇒ product

pages/%.html: %.mkd main.css main.header.html main.footer.html
	$(mds_r)

push_all:
	cd pages && ! git commit -am "Orphan commit!"
	cd pages && git pull || ( echo "WAIT: Don't push_all until you can pull" && false)
	$(MAKE) $(pageProducts)
	cd pages && git add $(pageProductsLocal) && git pull && git push

all.time: push_all
