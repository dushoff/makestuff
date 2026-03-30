from Bio import Entrez   
from Bio import Medline
from sys import argv
import re
import os

bib = "bibdir/"

Entrez.email = "jdushoff@gmail.com"  
maxRecords = 1000
script, filename = argv
txt = open(filename)
SearchTerm = txt.read()

idlist = []
pattern = r'^[\s\*\#]*PMID:\s*(\w+)'

# Open and read the file line by line
with open(filename, 'r') as file:
	for line in file:
		line = line.strip()
		match = re.match(pattern, line)
		if match:
			pmid = match.group(1)
			base = f"{bib}PM{pmid}"
			rec = base + ".rec"
			corr = base + ".corr"
			if os.path.exists(corr):
				os.system(f"cat {corr}")
			elif os.path.exists(rec):
				os.system(f"cat {rec}")
			else:
				idlist.append(pmid)

if idlist:
	handle = Entrez.efetch(db="pubmed", id=idlist, rettype="medline",retmode="text")
	records = list(Medline.parse(handle))
	for record in records:
		reclist = []
		for key in record.keys():
			f = record[key]
			if type(f) is list:
				for e in f:
					reclist.append(f"{key}: {e}")
			else:
				reclist.append(f"{key}: {f}")
		rec = "\n".join(reclist) + "\n\n"

		fn = f"{bib}PM{record['PMID']}.rec"
		## print(fn)
		with open(fn, "w") as recfile:
			recfile.write(rec)
		## There's a weird inconsistency with the blank lines
		## Solved by using the new file instead of the contents. 
		os.system(f"cat {fn}")

