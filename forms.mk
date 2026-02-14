include makestuff/forms.def

Ignore += formDrop
formDrop/%: |  formDrop ;
formDrop: dir = $(formDrop)
formDrop: 
	$(linkdirname)

Ignore += date.txt
date.txt:
	$(MAKE) up_date

Ignore += *.echo.txt
%.echo.txt:
	echo $* > $@

name.txt:
	echo "Jonathan Dushoff" > $@

X.txt:
	echo "X" > $@

up_date: 
	date +"%d %b %Y" > date.txt

%.trim.txt: %.txt
	sed -e "s/##*  *.*//" $< > $@

%.txt.pdf: %.txt.ps
	ps2pdf $< > $@

## This all seems like a disaster; files are sometimes local and sometimes in formDrop!

## Refactor this! Sig uses a different paradimg, can it be matched?
text.pdf: text.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 0.9in 0.2in" -stdin -o $@ 

X.pdf: X.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 0.9in 0.2in" -stdin -o $@ 

name.pdf: name.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 1.40in 0.25in" -stdin -o $@ 

email.pdf: email.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 1.40in 0.25in" -stdin -o $@ 

date.pdf: date.txt
	pdfroff $< | cpdf -crop "0.9in 10.8in 0.9in 0.2in" -stdin -o $@ 

text_%.pdf: text.pdf
	cpdf -scale-page "$* $*" -o $@ $<

date_%.pdf: date.pdf
	cpdf -scale-page "$* $*" -o $@ $<

name_%.pdf: name.pdf
	cpdf -scale-page "$* $*" -o $@ $<

X_%.pdf: X.pdf
	cpdf -scale-page "$* $*" -o $@ $<

######################################################################

## Deprecate this stuff? Use pdf pipeline above? 2022 May 23 (Mon)
date.png name.png: %.png: %.pdf
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

## Suppressing 2025 Jul 06 (Sun)
## %.txt.ps: %.txt; groff $< > $@

%.txt.pdf: %.txt
	pdfroff $< > $@

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

%.straight.jpg: %.right.jpg
	convert -rotate 270 $< $@

## pdfpages stuff deleted 2021 Apr 14 (Wed)
## WHY?? Some sort of conflict, probably between pcard and Downloads
## Reinstating for now

include makestuff/pdfsplit.mk

######################################################################

## Page selection?

%.select.pdf:
	$(MAKE) $(basename $*).pdf
	pdfjam -o $@ $(basename $*).pdf $(subst .,,$(suffix $*))

######################################################################

## Requires cups-pdf.apt

~/PDF:
	cd ~ && $(mkdir)

%.print.pdf: %.pdf | ~/PDF
	$(cups_print)

define cups_print
	-rm -fr ~/PDF/*.*
	lpr -P PDF $<
	sleep 2
	$(MV) ~/PDF/*.* $@
endef
