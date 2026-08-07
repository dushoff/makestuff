from Bio import Entrez
from Bio import Medline
from sys import argv
import requests
import re
import os

bib = "bibdir/"
Entrez.email = "jdushoff@gmail.com"
maxRecords = 1000
script, filename = argv

pmid_pattern  = r'^[\s\*\#]*PMID:\s*(\S+)'
pmcid_pattern = r'^[\s\*\#]*PMCID:\s*(\S+)'
doi_pattern   = r'^[\s\*\#]*DOI:\s*(\S+)'

def resolve_pmid(term, label):
	handle = Entrez.esearch(db="pubmed", term=term, retmax=1)
	result = Entrez.read(handle)
	ids = result["IdList"]
	if ids:
		return ids[0]
	print(f"ERROR: could not resolve PMID for {label}")
	return None

entries = []
with open(filename, 'r') as file:
	for line in file:
		line = line.strip()
		m = re.match(pmid_pattern, line)
		if m:
			entries.append({"PMID": m.group(1)})
			continue
		m = re.match(pmcid_pattern, line)
		if m:
			entries.append({"PMCID": m.group(1)})
			continue
		m = re.match(doi_pattern, line)
		if m:
			entries.append({"DOI": m.group(1)})

idlist = []
entry_pmids = {}

for entry in entries:
	if "PMID" in entry:
		pmid = entry["PMID"]
	elif "PMCID" in entry:
		pmcid = entry["PMCID"]
		pmid = resolve_pmid(f"{pmcid}[PMC]", f"PMCID:{pmcid}")
		if pmid is None:
			continue
	elif "DOI" in entry:
		doi = entry["DOI"]
		pmid = resolve_pmid(f"{doi}[DOI]", f"DOI:{doi}")
		if pmid is None:
			continue

	base = f"{bib}PM{pmid}"
	rec  = base + ".rec"
	corr = base + ".corr"
	if os.path.exists(corr):
		os.system(f"cat {corr}")
	elif os.path.exists(rec):
		os.system(f"cat {rec}")
	else:
		idlist.append(pmid)

if idlist:
	handle = Entrez.efetch(db="pubmed", id=idlist, rettype="medline", retmode="text")
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
		with open(fn, "w") as recfile:
			recfile.write(rec)
		os.system(f"cat {fn}")
