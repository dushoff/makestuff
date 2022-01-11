%.four.pdf: %.pdf
	pdfjam -o $@ --nup '2x2' $<
