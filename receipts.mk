%.1.receipt.pdf: page=1
%.2.receipt.pdf: page=2
%.3.receipt.pdf: page=3
%.4.receipt.pdf: page=4
%.5.receipt.pdf: page=5
%.6.receipt.pdf: page=6
%.7.receipt.pdf: page=7
%.8.receipt.pdf: page=8
%.1.receipt.pdf %.2.receipt.pdf %.3.receipt.pdf %.4.receipt.pdf %.5.receipt.pdf %.6.receipt.pdf %.7.receipt.pdf %.8.receipt.pdf: %.pdf
	cpdf -add-text "$(page)" -topright 30 -font-size 24 $< -o $@

%.png.pdf: %.png
	$(convert)
