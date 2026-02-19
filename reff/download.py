from pubmed_pdf_downloader import downloader
from doi2pdf import doi2pdf
import subprocess
import shutil
from sys import argv
import re
import os
import mimetypes

script, filename, *other = argv
pyscr = "pyvenv/bin/"
fetched = "fetched_pdfs/"
doibase = "https://doi.org/"
pmcbase = "https://pmc.ncbi.nlm.nih.gov/articles/"
testfile = "library/testfile"

with open(filename, 'r', encoding='utf-8') as f:
	content = f.read()

paragraphs = content.strip().split('\n\n')
records = []

for para in paragraphs:
	entry = {}
	lines = para.strip().split('\n')
	for line in lines:
		if ':' in line:
			key, value = line.split(':', 1)
			entry[key.strip()] = value.strip()
	records.append(entry)

for record in records:
	fn = f"library/{record['TAG']}.pdf"
	print()
	if os.path.exists(fn):
		print(f"{fn} found")
	elif 'PMC' in record:
		pmc = record['PMC']
		try:
			subprocess.run([f"{pyscr}pubmed-pdf-downloader", "-pmcids", pmc])
			shutil.move(f"{fetched}{pmc}.pdf", fn)
			print(f"{fn} downloaded from PMC")
		except:
			print(f"{fn} COULD NOT BE downloaded from\n* {pmcbase}{pmc}")
	if not os.path.exists(fn):
		if 'DOI' in record:
			doi = record['DOI']
			try:
				doi2pdf(doi, output=testfile)
				mime_type, _ = mimetypes.guess_type(testfile)
				if mime_type == "application/pdf":
					shutil.move(testfile, fn)
					print(f"{fn} downloaded from DOI")
				else: 
					print(f"{fn} COULD NOT get pdf from\n* {doibase}{doi}")
					os.remove(testfile)
			except:
				print(f"{fn} COULD NOT BE downloaded from\n* {doibase}{doi}")

