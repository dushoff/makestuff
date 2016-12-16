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
	pdfroff $< > $@

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

sig.%.jpg: $(gitroot)/Correspondence/sig.jpg
	convert -scale $*% $< $@

sig.%.png: $(gitroot)/Correspondence/sig.png
	convert -scale $*% $< $@

sig.%.pdf: sig.%.jpg
	convert $< $@

%.ppmed.png: %.pdf
	convert -density 400x400 $< $@

include $(ms)/RR/pdf.mk
