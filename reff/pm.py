from Bio import Entrez   
from Bio import Medline
import numpy as np
import pickle
import re
from sys import argv

Entrez.email = "jdushoff@gmail.com"  

maxRecords = 2

script, filename = argv
with open(filename, 'r') as file:
	for line in file:
		line = line.strip()
		line = re.sub(r".*doi\.org/", "", line)
		if line.startswith("#"):
			continue
    # process the line here
		if line:
			handle = Entrez.esearch(db="pubmed", term=line, retmax=maxRecords) 
			records = Entrez.read(handle)
			if records["IdList"]:
				if len(records)>1:
					print(f"Warning: Multiple records found for {line}")
				id = records["IdList"][0]
				print(f"PMID: {id}")
			else:
				print(f"Warning: No records found for {line}")
