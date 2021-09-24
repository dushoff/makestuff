## See also makestuff/pngpages.mk

ifndef convert
	convert=convert
endif

.PRECIOUS: %-0.png
%-0.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-1.png
%-1.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-2.png
%-2.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-3.png
%-3.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-4.png
%-4.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-5.png
%-5.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-6.png
%-6.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-7.png
%-7.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-8.png
%-8.png: %.Rout.pdf
	convert $< $*.png

.PRECIOUS: %-9.png
%-9.png: %.Rout.pdf
	convert $< $*.png
