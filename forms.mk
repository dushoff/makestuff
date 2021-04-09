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

%.pdf: %.png
	convert $< $@

%.pdf: %.jpg
	convert $< $@

## Initials
formDrop/jd.%.jpg: formDrop/jd.jpg
	convert -scale $*% $< $@

formDrop/jsig.%.jpg: formDrop/jsig.jpg
	convert -scale $*% $< $@

formDrop/csig.%.jpg: formDrop/csig.png
	convert -scale $*% $< $@

sig.%.pdf: sig.%.jpg
	convert $< $@

%.ppmed.png: %.pdf
	convert -density 400x400 $< $@

.PRECIOUS: %-0.pdf
%-0.pdf: %.pdf
	pdfjam  $< 1 --outfile $@

.PRECIOUS: %-1.pdf
%-1.pdf: %.pdf
	pdfjam  $< 2 --outfile $@

.PRECIOUS: %-2.pdf
%-2.pdf: %.pdf
	pdfjam  $< 3 --outfile $@

.PRECIOUS: %-3.pdf
%-3.pdf: %.pdf
	pdfjam  $< 4 --outfile $@

.PRECIOUS: %-4.pdf
%-4.pdf: %.pdf
	pdfjam  $< 5 --outfile $@

.PRECIOUS: %-5.pdf
%-5.pdf: %.pdf
	pdfjam  $< 6 --outfile $@

.PRECIOUS: %-6.pdf
%-6.pdf: %.pdf
	pdfjam  $< 7 --outfile $@

.PRECIOUS: %-7.pdf
%-7.pdf: %.pdf
	pdfjam  $< 8 --outfile $@

.PRECIOUS: %-8.pdf
%-8.pdf: %.pdf
	pdfjam  $< 9 --outfile $@

.PRECIOUS: %-9.pdf
%-9.pdf: %.pdf
	pdfjam  $< 10 --outfile $@

.PRECIOUS: %.page.pdf
%.page.pdf: %.Rout.pdf
	pdfxup --outfile $@ --nup '2x2' $<
 
