
from Bio import Entrez
from Bio import Medline
from sys import argv
import requests
import re
import os
import sys
import xml.etree.ElementTree as ET

bib = "bibdir/"
Entrez.email = "jdushoff@gmail.com"
maxRecords = 1000
script, filename = argv

<<<<<<< HEAD
pmid_pattern  = r'^[\s\*\#]*PMID:\s*(\S+)'
pmcid_pattern = r'^[\s\*\#]*PMCID:\s*(\S+)'
doi_pattern   = r'^[\s\*\#]*DOI:\s*(\S+)'
arxiv_pattern = r'^[\s\*\#]*ARXIV:\s*(\S+)'
arxivdoi = "10.48550/arxiv."
arxivapi = "https://export.arxiv.org/api/query?id_list="
atom = "{http://www.w3.org/2005/Atom}"

## Make a MEDLINE-style record from the arXiv API, so that arXiv-only papers go through the pipeline
def arxiv_rec(arxiv):
	try:
		r = requests.get(arxivapi + arxiv, timeout=30)
		entry = ET.fromstring(r.content).find(atom + "entry")
		title = entry.find(atom + "title").text
	except Exception:
		print(f"ERROR: could not fetch arXiv record for {arxiv}", file=sys.stderr)
		return None
	reclist = []
	for author in entry.findall(atom + "author"):
		name = author.find(atom + "name").text.split()
		## Keep particles like "van de" with the surname
		k = len(name) - 1
		while k > 1 and name[k-1].islower():
			k -= 1
		reclist.append(f"FAU: {' '.join(name[k:])}, {' '.join(name[:k])}")
	reclist.append(f"TI: {' '.join(title.split())}")
	reclist.append("TA: arXiv")
	reclist.append(f"DP: {entry.find(atom + 'published').text[:4]}")
	reclist.append(f"AID: 10.48550/arXiv.{arxiv} [doi]")
	reclist.append(f"AB: {' '.join(entry.find(atom + 'summary').text.split())}")
	return "\n".join(reclist) + "\n\n"
=======
pmid_pattern  = r'^[\s\*]*PMID:\s*(\S+)'
pmcid_pattern = r'^[\s\*]*PMCID:\s*(\S+)'
doi_pattern   = r'^[\s\*]*DOI:\s*(\S+)'
>>>>>>> a0607080081b6aea925418b1b168334f49306b1f

def resolve_pmid(term, label):
	handle = Entrez.esearch(db="pubmed", term=term, retmax=1)
	result = Entrez.read(handle)
	ids = result["IdList"]
	if ids:
		return ids[0]
	print(f"ERROR: could not resolve PMID for {label}", file=sys.stderr)
	return None

entries = []
with open(filename, 'r') as file:
	for line in file:
		line = line.strip()
		m = re.match(pmid_pattern, line)
		if m:
			entries.append({"PMID": m.group(1), "call": f"PMID:{m.group(1)}"})
			continue
		m = re.match(pmcid_pattern, line)
		if m:
			entries.append({"PMCID": m.group(1), "call": f"PMCID:{m.group(1)}"})
			continue
		m = re.match(doi_pattern, line)
		if m and m.group(1).lower().startswith(arxivdoi):
			arxiv = m.group(1)[len(arxivdoi):]
			entries.append({"ARXIV": arxiv, "call": f"DOI:{m.group(1)}"})
			continue
		if m:
			entries.append({"DOI": m.group(1), "call": f"DOI:{m.group(1)}"})
			continue
		m = re.match(arxiv_pattern, line)
		if m:
			entries.append({"ARXIV": m.group(1), "call": f"ARXIV:{m.group(1)}"})

idlist = []
pmid_calls = {}  # pmid -> list of call strings

for entry in entries:
	call = entry["call"]
	if "ARXIV" in entry:
		arxiv = entry["ARXIV"]
		base = f"{bib}ARXIV{arxiv.replace('/', '_')}"
		rec  = base + ".rec"
		corr = base + ".corr"
		if os.path.exists(corr):
			os.system(f"cat {corr}")
		elif os.path.exists(rec):
			os.system(f"cat {rec}")
		else:
			text = arxiv_rec(arxiv)
			if text:
				with open(rec, "w") as recfile:
					recfile.write(text)
				print(text, end="")
		continue
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

	pmid_calls.setdefault(pmid, []).append(call)

	base = f"{bib}PM{pmid}"
	rec  = base + ".rec"
	corr = base + ".corr"
	if os.path.exists(corr):
		os.system(f"cat {corr}")
	elif os.path.exists(rec):
		os.system(f"cat {rec}")
	else:
		if pmid not in idlist:
			idlist.append(pmid)

for pmid, calls in pmid_calls.items():
	if len(calls) > 1:
		print(f"DUPLICATE PMID {pmid}: {', '.join(calls)}", file=sys.stderr)

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
