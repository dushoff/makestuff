Ignore += *.page.pdf
%.page.pdf: %.Rout.pdf
	pdfnup --outfile $@ --nup '2x2' $<

Ignore += *.wide.pdf
%.wide.pdf: %.Rout.pdf
	pdfnup --outfile $@ --nup '2x1' $<
