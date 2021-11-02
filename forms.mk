include makestuff/forms.def

formDrop: dir = $(formDrop)
formDrop: 
	$(linkdirname)

date.txt:
	$(MAKE) up_date

up_date: 
	date +"%d %b %Y" > date.txt

%.txt.pdf: %.txt.ps
	ps2pdf $< > $@

## This all seems like a disaster; files are sometimes local and sometimes in formDrop!

text.pdf: text.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 0.9in 0.2in" -stdin -o $@ 

name.pdf: name.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 1.40in 0.25in" -stdin -o $@ 

email.pdf: email.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 1.40in 0.25in" -stdin -o $@ 

date.pdf: date.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 0.9in 0.2in" -stdin -o $@ 

date_%.pdf: date.pdf
	cpdf -scale-page "$* $*" -o $@ $<

######################################################################

## Deprecate this stuff?
date.png: date.pdf
	$(imageconvert)

date.%.png: date.png
	convert -scale $*% $< $@

date.%.jpg: date.jpg
	convert -scale $*% $< $@

name.%.png: name.png
	convert -scale $*% $< $@

%.img.jpg: %.pdf
	$(imageconvert)

%.img.png: %.pdf
	$(imageconvert)

%.txt.ps: %.txt
	groff $< > $@

######################################################################

formDrop/earnsig.%.png: formDrop/earnsig.png
	convert -scale $*% $< $@

formDrop/csig.%.jpg: formDrop/csig.jpg
	convert -scale $*% $< $@

## Initials
formDrop/jd.%.jpg: formDrop/jd.jpg
	convert -scale $*% $< $@

formDrop/jsig.%.jpg: formDrop/jsig.jpg
	convert -scale $*% $< $@

formDrop/csig.%.jpg: formDrop/csig.png
	convert -scale $*% $< $@

csig.%.pdf: csig.%.jpg
	convert $< $@

jsig.%.pdf: jsig.%.jpg
	convert $< $@

sig.%.pdf: sig.%.jpg
	convert $< $@

%.ppmed.png: %.pdf
	convert -density 400x400 $< $@

%.jpg: %.right.jpg
	convert -rotate 270 $< $@

## pdfpages stuff deleted 2021 Apr 14 (Wed)
## WHY?? Some sort of conflict, probably between pcard and Downloads
## Reinstating for now

include makestuff/pdfsplit.mk
