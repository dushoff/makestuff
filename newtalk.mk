ifndef PUSHSTAR
include makestuff/perl.def
endif

Ignore += talkdir

Ignore += *.txt.fmt txt.format
%.txt.fmt: txt.format $(talkdir)/fmt.pl
	$(PUSHSTAR)

txt.format: $(talkdir)/txt.format local.txt.format
	$(rm)
	$(cat)
	$(RO)

local.txt.format:
	touch $@

## tmp files should be de-protected and sourced if you want to change locally
%.tmp: 
	$(MAKE) talkdir
	$(CP) $(talkdir)/$@ .
	$(RO)

ici3d:
	/bin/ln -fs talkdir/ici3d.tmp beamer.tmp

## What is this?
copy.tex:
	$(MAKE) talkdir
	$(CP) $(talkdir)/$@ .
	$(RO)

.PRECIOUS: talkdir/%
talkdir/%:
	$(MAKE) talkdir

Makefile: 
talkdir:
	/bin/ln -fs $(talkdir) $@

Ignore += *.final.*
.PRECIOUS: %.final.tex
%.final.tex: %.txt beamer.tmp final.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

Ignore += *.draft.*
.PRECIOUS: %.draft.tex
%.draft.tex: %.txt beamer.tmp draft.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

Ignore += *.slides.*
.PRECIOUS: %.slides.tex
%.slides.tex: %.final.tex  $(talkdir)/nopause.pl
	$(PUSH)

Ignore += *.handouts.*
.PRECIOUS: %.handouts.tex
%.handouts.tex: %.txt notes.tmp handouts.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

Ignore += *.complete.*
.PRECIOUS: %.complete.tex
%.complete.tex: %.txt notes.tmp complete.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

Ignore += *.outline.*
.PRECIOUS: %.outline.tex
%.outline.tex: %.txt notes.tmp outline.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

%.note: %
	$(CP) $< $(gitroot)/notebook/materials/

%.notebook: %.note
	cd $(gitroot)/notebook/ && make remotesync

# include makestuff/resources.mk
