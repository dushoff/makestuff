%.page.pdf: %.Rout.pdf
	pdfnup --outfile $@ --nup '2x2' $<
