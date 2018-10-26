Autorefs is fairly hacky part of makestuff. It is meant to take DOI or pubmed identifiers and find reference information.

As soon as autorefs is run, it will set up a directory called bibdir. It will first try to find $(Drop)/autorefs and link that, otherwise it just makes something local that may eventually get annoying (because people will keep pulling the same stuff)
