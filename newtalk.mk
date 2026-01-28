ifndef PUSHSTAR
include makestuff/perl.def
endif

ifndef talkdir
include makestuff/newtalk.def
endif

Ignore += talkdir

Ignore += *.txt.fmt txt.format *.TXT
.PRECIOUS: %.txt.fmt
%.txt.fmt: txt.format $(talkdir)/fmt.pl
	$(PUSHSTAR)

txt.format: $(talkdir)/txt.format local.txt.format
	$(rm)
	$(catro)

local.txt.format:
	touch $@

## Not sure what this was for -- there's an additional localcomm pathway anyway (see beamer.tex)
## localcomm.TEX: ; $(touch)

## tmp files should be de-protected and sourced if you want to change locally
%.tmp: 
	$(MAKE) talkdir
	$(CP) $(talkdir)/$@ .
	$(readonly)

ici3d:
	/bin/ln -fs talkdir/ici3d.tmp beamer.tmp

## What is this?
copy.tex:
	$(MAKE) talkdir
	$(CP) $(talkdir)/$@ .
	$(readonly)

.PRECIOUS: talkdir/%
talkdir/%:
	$(MAKE) talkdir

Makefile: 
talkdir:
	/bin/ln -fs $(talkdir) $@

## What is THIS?? 2025 Jul 22 (Tue)
%.TXT: %.txt
	$(copy)

Ignore += *.final.*
.PRECIOUS: %.final.tex
%.final.tex: %.TXT beamer.tmp final.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

## For debugging talks?? 2025 Jul 23 (Wed)
Ignore += *.now.*
.PRECIOUS: %.now.tex
%.now.tex: %.TXT beamer.tmp draft.txt.fmt talkdir/now.fmt talkdir/lect.pl
	$(PUSH)

Ignore += *.slides.*
.PRECIOUS: %.slides.tex
%.slides.tex: %.TXT beamer.tmp slides.txt.fmt $(talkdir)/lect.pl
	$(PUSH)
## What was this? I hate myself
## %.slides.tex: %.final.tex  $(talkdir)/nopause.pl

Ignore += *.talk.*
%.talk.pdf: %.final.pdf %.draft.pdf
	$(pdfcat)

Ignore += *.draft.*
.PRECIOUS: %.draft.tex
%.draft.tex: %.TXT beamer.tmp draft.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

	$(PUSH)

Ignore += *.handouts.*
.PRECIOUS: %.handouts.tex
%.handouts.tex: %.TXT notes.tmp handouts.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

Ignore += *.complete.*
.PRECIOUS: %.complete.tex
%.complete.tex: %.TXT notes.tmp complete.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

Ignore += *.outline.*
.PRECIOUS: %.outline.tex
%.outline.tex: %.TXT notes.tmp outline.txt.fmt $(talkdir)/lect.pl
	$(PUSH)

%.note: %
	$(CP) $< $(gitroot)/notebook/materials/

%.notebook: %.note
	cd $(gitroot)/notebook/ && make remotesync

# include makestuff/resources.mk
