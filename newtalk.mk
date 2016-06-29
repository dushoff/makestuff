%.txt.fmt: txt.format $(talkdir)/fmt.pl
	$(PUSHSTAR)

txt.format: $(talkdir)/txt.format local.txt.format
	$(cat)

local.txt.format:
	touch $@

## tmp files should be de-protected and sourced if you want to change locally
%.tmp: talkdir
	$(CP) $(talkdir)/$@ .
	$(RO)

talkdir:
	/bin/ln -fs $(talkdir) $@

.PRECIOUS: %.draft.tex
%.draft.tex: %.txt beamer.tmp draft.txt.fmt $(talkdir)/lect.pl
	$(PUSH)
 
.PRECIOUS: %.final.tex
%.final.tex: %.txt beamer.tmp combined.fmt $(talkdir)/lect.pl
	$(PUSH)

.PRECIOUS: %.outline.tex
%.outline.tex: %.txt outline.tmp outline.fmt $(talkdir)/lect.pl
	$(PUSH)

include $(talkdir)/resources.mk
