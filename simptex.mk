
%.pdf: %.tex
	pdflatex $*; sleep 1
	@!(grep "Fatal error occurred" $*.log)
	-@(grep "Rerun to get" $*.log && touch $<)
	-@(grep "Error:" $*.log && touch $<)

tclean:
	$(RM) *.aux *.bbl


