
.PRECIOUS: %-0.pdf
%-0.pdf: %.pdf
	pdfjam $< 1 --outfile $@

.PRECIOUS: %-1.pdf
%-1.pdf: %.pdf
	pdfjam $< 2 --outfile $@

.PRECIOUS: %-2.pdf
%-2.pdf: %.pdf
	pdfjam $< 3 --outfile $@

.PRECIOUS: %-3.pdf
%-3.pdf: %.pdf
	pdfjam $< 4 --outfile $@

.PRECIOUS: %-4.pdf
%-4.pdf: %.pdf
	pdfjam $< 5 --outfile $@

.PRECIOUS: %-5.pdf
%-5.pdf: %.pdf
	pdfjam $< 6 --outfile $@

.PRECIOUS: %-6.pdf
%-6.pdf: %.pdf
	pdfjam $< 7 --outfile $@

.PRECIOUS: %-7.pdf
%-7.pdf: %.pdf
	pdfjam $< 8 --outfile $@

.PRECIOUS: %-8.pdf
%-8.pdf: %.pdf
	pdfjam $< 9 --outfile $@

.PRECIOUS: %-9.pdf
%-9.pdf: %.pdf
	pdfjam $< 10 --outfile $@
