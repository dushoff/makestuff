
%.pdf: %.tex
	-/bin/cp -f $*.aux .$*.aux
	-/bin/cp -f $*.nav .$*.nav
	pdflatex $*; sleep 1
	diff .$*.aux $*.aux > /dev/null || touch $*.aux
	diff .$*.nav $*.nav > /dev/null || touch $*.aux

tclean:
	$(RM) *.aux *.bbl


