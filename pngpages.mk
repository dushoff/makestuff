ifndef convert
	convert=convert
endif

%-0.png %-1.png %-2.png %-3.png %-4.png %-5.png %-6.png %-7.png %-8.png %-9.png: %-fake.png ;

%-fake.png: %.pdf
	$(convert0
