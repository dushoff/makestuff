include $(ms)/forms.def

formDrop: dir = $(formDrop)
formDrop: 
	$(linkdirname)

date.txt:
	(MAKE) up_date

up_date: 
	date +"%d %b %Y" > date.txt

%.img.jpg: %.pdf
	$(imageconvert)

%.img.png: %.pdf
	$(imageconvert)

%.txt.ps: %.txt
	groff $< > $@

%.txt.pdf: %.txt.ps
	ps2pdf $< > $@

date.pdf: date.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 0.9in 0.2in" -stdin -o $@ 

date_%.pdf: date.pdf
	cpdf -scale-page "$* $*" -o $@ $<

date.png: date.pdf
	$(imageconvert)

date.%.png: date.png
	convert -scale $*% $< $@

date.%.jpg: date.jpg
	convert -scale $*% $< $@

name.pdf: name.txt
	pdfroff $< > $@

name.%.png: name.png
	convert -scale $*% $< $@

formDrop/sig.%.jpg: formDrop/sig.jpg
	convert -scale $*% $< $@

sig.%.pdf: sig.%.jpg
	convert $< $@

%.ppmed.png: %.pdf
	convert -density 400x400 $< $@

-include $(ms)/wrapR/pdf.mk
