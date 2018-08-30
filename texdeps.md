`texdeps.mk` is meant to make pdf files from latex files.

It is in development.

It is part of makestuff, a crazy github repo with various makefiles I like to use.

You can change the texdeps behaviour by presetting the following make variables:
* latex (preset to `pdflatex -interaction=nonstopmode`)
* bibtex (preset to `bibtex = biber $* || bibtex $*`; don't forget `$*` if you reset it.

