`texdeps.mk` is meant to make pdf files from latex files.

It is in development.

It is part of makestuff, a crazy github repo with various makefiles I like to use.

You can change the texdeps behaviour by presetting the following make variables:
* latex (defaults to `pdflatex -interaction=nonstopmode`)
* bibtex (defaults to `bibtex = biber $* || bibtex $*`; don't forget `$*` if you set it.

The goal of texdeps is to make a pdf file from a tex file (if your make environment makes the tex file, it should chain and make that as well). It will do this by:
* Going through your tex file and make a corresponding .mk file (hidden a file called .texdeps)
* Using the .mk file to make things that your .tex file needs:
	* Any file referred to in \includegraphics
	* Any file that is input or included -- it does _not_ autocomplete missing extensions:
		* if you want texdeps to work, add `.tex` explicitly
		* if you want it to not work, add `no_texdeps` after a % sign at the end of the line
	* .bbl files
	* Any directory referred to above, or in a package call

texdeps goes through what it considers to be one reasonable cycle when you hit `make`; it does loop and try to finish, but instead searches for "Rerun to get", and uses it to put the target out of date in some hopefully intelligent way. It should also put "Rerun" up on the screen to warn you. This is roughly the original tex behaviour; the idea being that if you're actively working, you don't need to re-re-update every cross-reference every time you want to see your document.
