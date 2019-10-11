## Directory links

Ignore += lect
.PRECIOUS: lect/%
lect/%: 
	$(MAKE) lect

Ignore += newtalk
.PRECIOUS: newtalk/%
newtalk/%: 
	$(MAKE) newtalk

lect newtalk: 
	/bin/ln -s makestuff/$@ .

###################################################################
 
.PRECIOUS: %.course.tex
%.course.tex: %.dmu beamer.tmp bdraft.fmt newtalk/lect.pl
	$(PUSH)
 
.PRECIOUS: %.final.tex
%.final.tex: %.txt beamer.tmp combined.fmt newtalk/lect.pl
	$(PUSH)

.PRECIOUS: %.outline.tex
%.outline.tex: %.txt outline.tmp outline.fmt newtalk/lect.pl
	$(PUSH)
