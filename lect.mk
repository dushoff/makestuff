
lect/%: lect ;

## talk/%: talk ;

# talk lect: 
lect: 
	/bin/ln -s $(ms)/$@ .

bdraft.fmt: beamer.fmt $(talkdir)/bd.pl
	$(PUSH)

###################################################################
 
.PRECIOUS: %.course.tex
%.course.tex: %.dmu beamer.tmp bdraft.fmt $(talkdir)/lect.pl
	$(PUSH)
 
.PRECIOUS: %.final.tex
%.final.tex: %.txt beamer.tmp combined.fmt $(talkdir)/lect.pl
	$(PUSH)

.PRECIOUS: %.outline.tex
%.outline.tex: %.txt outline.tmp outline.fmt $(talkdir)/lect.pl
	$(PUSH)
