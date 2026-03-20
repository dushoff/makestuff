2025 Oct 24 (Fri) Autorefs does not seem reliable anymore. It is returning "not found" at random, I guess because of the not-completely-legal polling method

Autorefs is fairly hacky part of makestuff. It is meant to take DOI or pubmed identifiers and find reference information.

As soon as autorefs is run, it will set up a directory called bibdir. It will first try to find $(Drop)/autorefs and link that, otherwise it just makes something local that may eventually get annoying (because people will keep pulling the same stuff)
