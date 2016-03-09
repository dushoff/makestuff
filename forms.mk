up_date:
	/bin/rm -f date.txt

date.txt: 
	date +"%d %b %Y" > $@

date.pdf: date.txt
	pdfroff $< > $@

date.png: date.txt Makefile
	convert -density 300 -crop 340x76+20+35 $< $@

date.%.png: date.png
	convert -scale $*% $< $@

date.jpg: date.txt
	convert -crop 90x28+36+32 $< $@

date.%.jpg: date.jpg
	convert -scale $*% $< $@

name.pdf: name.txt
	pdfroff $< > $@

name.%.png: name.png
	convert -scale $*% $< $@

sig.%.jpg: sig.jpg
	convert -scale $*% $< $@

sig.%.png: sig.png
	convert -scale $*% $< $@

%.ppmed.png: %.pdf
	convert -density 400x400 $< $@

include $(ms)/RR/pdf.mk
