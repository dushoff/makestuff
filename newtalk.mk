%.txt.fmt: txt.format $(talkdir)/fmt.pl
	$(PUSHSTAR)

txt.format: $(talkdir)/txt.format local.txt.format
	$(cat)

local.txt.format:
	touch $@

## tmp files should be de-protected and sourced if you want to change locally
%.tmp: 
	$(MAKE) talkdir
	$(CP) $(talkdir)/$@ .
	$(RO)

## What is this?
copy.tex:
	$(MAKE) talkdir
	$(CP) $(talkdir)/$@ .
	$(RO)

talkdir:
	/bin/ln -fs $(talkdir) $@

.PRECIOUS: %.final.tex
%.final.tex: %.txt beamer.tmp final.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

.PRECIOUS: %.draft.tex
%.draft.tex: %.txt beamer.tmp draft.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

.PRECIOUS: %.handouts.tex
%.handouts.tex: %.txt notes.tmp handouts.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

# include $(ms)/resources.mk
