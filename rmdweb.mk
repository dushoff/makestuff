
## Developing at the same time as 20190744; need to revisit

## This rule should FILTER. 
mds_r = pandoc --mathjax -s -c main.css -B main.header.html -A main.footer.html -o $@ $<

## Source ⇒ product
