## Not handling bibtex yet. Only semi-makey by design
## Make repeatedly to get final version
define texHere
	pdflatex $<; sleep 1
	@!(grep "Fatal error occurred" $(basename $<).log)
	-@(grep "Rerun to get" $(basename $<).log && touch $<)
	-@(grep "Error:" $(basename $<).log && touch $<)
endef

define texThere
	cd $(dir $<) && pdflatex $(notdir $<); sleep 1
	@!(grep "Fatal error occurred" $(basename $<).log)
	-@(grep "Rerun to get" $(basename $<).log && touch $<)
	-@(grep "Error:" $(basename $<).log && touch $<)
endef

tclean:
	$(RM) *.aux *.bbl


