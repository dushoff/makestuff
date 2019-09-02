## Retrofits and hacks

## Bailed on getting the regex syntax write for the $. Watch out?
## Try [$$] if you're bored.
noms:
	perl -pi -e 's|.\(ms\)/|makestuff/|' Makefile *.mk

%.noms:
	perl -pi -e 's|.\(ms\)/|makestuff/|' $*/Makefile $*/*.mk
	
# Unix basics
MVF = /bin/mv -f
MV = /bin/mv
CP = /bin/cp
CPF = /bin/cp -f
CPR = /bin/cp -rf
DIFF = diff
GVEDIT = ($(VEDIT) $@ || gedit $@ || (echo ERROR: No editor found makestuff/unix.mk && echo set shell VEDIT variable && exit 1))
RMR = /bin/rm -rf
LS = /bin/ls
LN = /bin/ln -s
LNF = /bin/ln -fs
TGZ = tar czf $@ $^
MD = mkdir
MKDIR = mkdir
CAT = cat
ZIP = zip $@ $^
readonly = chmod a-w $@
RO = chmod a-w $@

null = /dev/null

hiddenfile = $(dir $1).$(notdir $1)
hide = $(MVF) $1 $(dir $1).$(notdir $1)
unhide = $(MVF) $(dir $1).$(notdir $1) $1
hcopy = $(CPF) $1 $(dir $1).$(notdir $1)
difftouch = diff $1 $(dir $1).$(notdir $1) > /dev/null || touch $1
touch = touch $@

makethere = cd $(dir $@) && $(MAKE) $(notdir $@)

diff = $(DIFF) $^ > $@

# Generic (vars that use the ones above)
link = $(LN) $< $@
alwayslinkdir = (ls $(dir)/$@ > $(null) || $(MD) $(dir)/$@) && $(LNF) $(dir)/$@ .
linkdir = ls $(dir)/$@ > $(null) && $(LNF) $(dir)/$@ .
linkdirname = ls $(dir) > $(null) && $(LNF) $(dir) $@ 

## This will make directory if it doesn't exist
## Possibly good for shared projects. Problematic if central user makes two 
## redundant dropboxes because of sync problems
alwayslinkdir = (ls $(dir)/$@ > $(null) || $(MD) $(dir)/$@) && $(LNF) $(dir)/$@ .

forcelink = $(LNF) $< $@
rcopy = $(CPR) $< $@
copy = $(CP) $< $@
hardcopy = $(CPF) $< $@
allcopy =  $(CP) $^ $@
ccrib = $(CP) $(crib)/$@ .
mkdir = $(MD) $@
cat = $(CAT) /dev/null $^ > $@
ln = $(LN) $< $@
lnf = $(LNF) $< $@
rm = $(RM) $@
pandoc = pandoc -o $@ $<
pandocs = pandoc -s -o $@ $<

# What?
convert = convert $< $@
imageconvert = convert -density 600 -trim $< -quality 100 -sharpen 0x1.0 $@
shell_execute = sh < $@

pdfcat = pdfjoin --outfile $@ $(filter %.pdf, $^) 

latexdiff = latexdiff $^ > $@

Ignore += *.ld.tex
%.ld.tex: %.tex
	latexdiff $*.tex.*.oldfile $< > $@

%.pd: %
	$(CP) $< $(pushdir)

%.pdown: %
	$(CP) $< ~/Downloads/

%.pushpush: %
	$(CP) $< $(pushdir)
	cd $(pushdir) && make remotesync

%.log: 
	$(RM) $*
	$(MAKE) $* > $*.makelog

%.makelog: %.log ;

## Jekyll stuff
serve:
	bundle exec jekyll serve &

killserve:
	killall jekyll
	sleep 1
	bundle exec jekyll serve &

## Convenience
%.tod: %
	$(CP) $< ~/Downloads

%.var:
	@echo $($*)
