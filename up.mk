%.four.pdf: %.pdf
	pdfnup --outfile $@ --nup '2x2' $<
