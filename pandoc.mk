%.html: %.md
	pandoc $< > $@
