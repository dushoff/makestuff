
date.txt: 
	date +"%d %b %Y" > $@

date.pdf: date.txt
	pdfroff $< > $@

date.png: date.txt
	convert -crop 90x28+36+32 $< $@

date.%.png: date.png
	convert -scale $*% $< $@

date.jpg: date.txt
	convert -crop 90x28+36+32 $< $@

date.%.jpg: date.png
	convert -scale $*% $< $@

name.pdf: name.txt
	pdfroff $< > $@

name.%.png: name.png
	convert -scale $*% $< $@

sig.%.jpg: $(ldrop)/sig.jpg
	convert -scale $*% $< $@

%.ppmed.png: %.pdf
	convert -density 400x400 $< $@
