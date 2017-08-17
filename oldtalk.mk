$(format_files):
	/bin/cp -f $(talkdir)/$@ .
	chmod a-w $@

bdraft.fmt: beamer.fmt $(talkdir)/bd.pl
	$(PUSH)

###################################################################
 
.PRECIOUS: %.draft.tex
%.draft.tex: %.txt beamer.tmp bdraft.fmt $(talkdir)/lect.pl
	$(PUSH)
 
.PRECIOUS: %.final.tex
%.final.tex: %.txt beamer.tmp combined.fmt $(talkdir)/lect.pl
	$(PUSH)

.PRECIOUS: %.outline.tex
%.outline.tex: %.txt outline.tmp outline.fmt $(talkdir)/lect.pl
	$(PUSH)
