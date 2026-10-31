from unpywall import Unpywall
from unpywall.utils import UnpywallCredentials
from sys import argv
import requests
import shutil
import mimetypes
import os

UnpywallCredentials('jdushoff@gmail.com')

script, filename, *other = argv
bib = "library/"
doibase = "https://doi.org/"
pmcbase = "https://pmc.ncbi.nlm.nih.gov/articles/"
arxivbase = "https://arxiv.org/pdf/"
arxivdoi = "10.48550/arxiv."

headers = {'User-Agent': 'Mozilla/5.0'}

def try_unpaywall(doi, fn):
	try:
		Unpywall.download_pdf_file(doi=doi, filename=fn)
		if os.path.exists(fn):
			with open(fn, 'rb') as f:
				if f.read(4) == b'%PDF':
					print(f"{fn} downloaded via Unpaywall")
					return True
			os.remove(fn)
			print(f"{fn} from Unpaywall was not a PDF; removed")
	except:
		pass
	return False

def try_arxiv(arxiv, fn):
	url = f"{arxivbase}{arxiv}"
	try:
		r = requests.get(url, headers=headers, allow_redirects=True, timeout=30)
		if r.status_code == 200 and r.content[:4] == b'%PDF':
			with open(fn, 'wb') as f:
				f.write(r.content)
			print(f"{fn} downloaded from arXiv")
			return True
	except:
		pass
	print(f"{fn} COULD NOT BE downloaded from\n* {url}")
	return False

def try_pmc(pmc, fn):
	url = f"{pmcbase}{pmc}/pdf/"
	try:
		r = requests.get(url, headers=headers, allow_redirects=True, timeout=15)
		if r.status_code == 200 and r.content[:4] == b'%PDF':
			with open(fn, 'wb') as f:
				f.write(r.content)
			print(f"{fn} downloaded from PMC")
			return True
	except:
		pass
	print(f"{fn} COULD NOT BE downloaded from\n* {url}")
	return False

def try_doi(doi, fn):
	url = f"{doibase}{doi}"
	try:
		r = requests.get(url, headers=headers, allow_redirects=True, timeout=15)
		if r.status_code == 200 and r.content[:4] == b'%PDF':
			with open(fn, 'wb') as f:
				f.write(r.content)
			print(f"{fn} downloaded from DOI")
			return True
	except:
		pass
	print(f"{fn} COULD NOT BE downloaded from\n* {url}")
	return False

with open(filename, 'r', encoding='utf-8') as f:
	content = f.read()
paragraphs = content.strip().split('\n\n')
records = []
for para in paragraphs:
	entry = {}
	for line in para.strip().split('\n'):
		if ':' in line:
			key, value = line.split(':', 1)
			entry[key.strip()] = value.strip()
	records.append(entry)

for record in records:
	if 'TAG' not in record:
		continue
	fn = f"{bib}{record['TAG']}.pdf"
	print()
	if os.path.exists(fn):
		print(f"{fn} found")
		continue

	doi = record.get('DOI')
	pmc = record.get('PMC')
	arxiv = record.get('ARXIV')
	if not arxiv and doi and doi.lower().startswith(arxivdoi):
		arxiv = doi[len(arxivdoi):]

	if pmc and try_pmc(pmc, fn):
		continue
	if doi and try_unpaywall(doi, fn):
		continue
	if doi and try_doi(doi, fn):
		continue
	if arxiv and try_arxiv(arxiv, fn):
		continue

	print(f"{fn} COULD NOT BE downloaded from any source")
