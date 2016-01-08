%.0.pdf: %.pdf
	pdftk $< cat 1 output $@

%.1.pdf: %.pdf
	pdftk $< cat 2 output $@

%.2.pdf: %.pdf
	pdftk $< cat 3 output $@

%.3.pdf: %.pdf
	pdftk $< cat 4 output $@

%.4.pdf: %.pdf
	pdftk $< cat 5 output $@

%.5.pdf: %.pdf
	pdftk $< cat 6 output $@

%.6.pdf: %.pdf
	pdftk $< cat 7 output $@

%.7.pdf: %.pdf
	pdftk $< cat 8 output $@

%.8.pdf: %.pdf
	pdftk $< cat 9 output $@

%.9.pdf: %.pdf
	pdftk $< cat 10 output $@

%-0.pdf: %.pdf
	pdftk $< cat 1 output $@

%-1.pdf: %.pdf
	pdftk $< cat 2 output $@

%-2.pdf: %.pdf
	pdftk $< cat 3 output $@

%-3.pdf: %.pdf
	pdftk $< cat 4 output $@

%-4.pdf: %.pdf
	pdftk $< cat 5 output $@

%-5.pdf: %.pdf
	pdftk $< cat 6 output $@

%-6.pdf: %.pdf
	pdftk $< cat 7 output $@

%-7.pdf: %.pdf
	pdftk $< cat 8 output $@

%-8.pdf: %.pdf
	pdftk $< cat 9 output $@

%-9.pdf: %.pdf
	pdftk $< cat 10 output $@

