%.html: %.md
	pandoc -s -o $@ $<

%.txt: %.md
	pandoc -o $@ $<

%.out: %.md
	pandoc -t plain -o $@ $<

%.html: %.csv
	csv2html -o $@ $<

