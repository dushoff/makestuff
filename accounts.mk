%.sheet.tsv:
	wget -O - "$($*.sheet)/export?format=tsv" | tr -d '\r' > $@

%.account.txt: %.tsv makestuff/accounts.pl
	$(PUSH)
