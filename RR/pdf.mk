%.0.pdf: %.pdf
	pdfjam $< 1 --outfile $@

%.1.pdf: %.pdf
	pdfjam $< 2 --outfile $@

%.2.pdf: %.pdf
	pdfjam $< 3 --outfile $@

%.3.pdf: %.pdf
	pdfjam $< 4 --outfile $@

%.4.pdf: %.pdf
	pdfjam $< 5 --outfile $@

%.5.pdf: %.pdf
	pdfjam $< 6 --outfile $@

%.6.pdf: %.pdf
	pdfjam $< 7 --outfile $@

%.7.pdf: %.pdf
	pdfjam $< 8 --outfile $@

%.8.pdf: %.pdf
	pdfjam $< 9 --outfile $@

%.9.pdf: %.pdf
	pdfjam $< 10 --outfile $@

%-0.pdf: %.pdf
	pdfjam $< 1 --outfile $@

%-1.pdf: %.pdf
	pdfjam $< 2 --outfile $@

%-2.pdf: %.pdf
	pdfjam $< 3 --outfile $@

%-3.pdf: %.pdf
	pdfjam $< 4 --outfile $@

%-4.pdf: %.pdf
	pdfjam $< 5 --outfile $@

%-5.pdf: %.pdf
	pdfjam $< 6 --outfile $@

%-6.pdf: %.pdf
	pdfjam $< 7 --outfile $@

%-7.pdf: %.pdf
	pdfjam $< 8 --outfile $@

%-8.pdf: %.pdf
	pdfjam $< 9 --outfile $@

%-9.pdf: %.pdf
	pdfjam $< 10 --outfile $@

