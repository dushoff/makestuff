## Retrofits and hacks

## Bailed on getting the regex syntax write for the $. Watch out?
## Try [$$] if you're bored.
noms:
	perl -pi -e 's|.\(ms\)/|makestuff/|' Makefile *.mk

%.noms:
	perl -pi -e 's|.\(ms\)/|makestuff/|' $*/Makefile $*/*.mk || perl -pi -e 's|.\(ms\)/|makestuff/|' $*/*.mk || perl -pi -e 's|.\(ms\)/|makestuff/|' $*/Makefile
	
# Unix basics (this is a hodge-podge of spelling conventions ☹)
MVF = /bin/mv -f
MV = /bin/mv
CP = /bin/cp
CPF = /bin/cp -f
CPR = /bin/cp -rf
DIFF = diff

## VEDIT is set in bashrc (and inherited)
## Not sure what I should do if it doesn't work?
GVEDIT = ($(VEDIT) $@ || gedit $@ || (echo ERROR: No editor found makestuff/unix.mk && echo set shell VEDIT variable && exit 1))
RMR = /bin/rm -rf
LS = /bin/ls
LN = /bin/ln -s
LNF = /bin/ln -fs
MD = mkdir
MKDIR = mkdir
CAT = cat
readonly = chmod a-w $@
RO = chmod a-w $@
RW = chmod ug+w $@
DNE = (! $(LS) $@ > $(null))
LSN = ($(LS) $@ > $(null))

## These two are weird (don't follow the convention)
TGZ = tar czf $@ $^
ZIP = zip $@ $^

null = /dev/null

lscheck = @$(LS) > $(null)

hiddenfile = $(dir $1).$(notdir $1)
hide = $(MVF) $1 $(dir $1).$(notdir $1)
unhide = $(MVF) $(dir $1).$(notdir $1) $1
hcopy = $(CPF) $1 $(dir $1).$(notdir $1)
difftouch = diff $1 $(dir $1).$(notdir $1) > /dev/null || touch $1
touch = touch $@

justmakethere = cd $(dir $@) && $(MAKE) $(notdir $@)
makethere = cd $(dir $@) && $(MAKE) makestuff && $(MAKE) $(notdir $@)
makestuffthere = cd $(dir $@) && $(MAKE) makestuff && $(MAKE) $(notdir $@)

diff = $(DIFF) $^ > $@

# Generic (vars that use the ones above)
link = $(LN) $< $@
alwayslinkdir = (ls $(dir)/$@ > $(null) || $(MD) $(dir)/$@) && $(LNF) $(dir)/$@ .
linkdir = ls $(dir)/$@ > $(null) && $(LNF) $(dir)/$@ .
linkdirname = ls $(dir) > $(null) && $(LNF) $(dir) $@ 
linkexisting = ls $< > /dev/null && $(link)

## This will make directory if it doesn't exist
## Possibly good for shared projects. Problematic if central user makes two 
## redundant dropboxes because of sync problems
alwayslinkdir = (ls $(dir)/$@ > $(null) || $(MD) $(dir)/$@) && $(LNF) $(dir)/$@ .

forcelink = $(LNF) $< $@
rcopy = $(CPR) $< $@
rdcopy = $(CPR) $(dir) $@
copy = $(CP) $< $@
hardcopy = $(CPF) $< $@
allcopy =  $(CP) $^ $@
ccrib = $(CP) $(crib)/$@ .
mkdir = $(MD) $@
makedir = cd $(dir $@) && $(MD) $(notdir $@)
cat = $(CAT) /dev/null $^ > $@
ln = $(LN) $< $@
lnf = $(LNF) $< $@
rm = $(RM) $@
pandoc = pandoc -o $@ $<
pandocs = pandoc -s -o $@ $<

## To copy a directory, be recursive, but don't accidentally copy _into_ an existing directory
## Maybe think about using dir $@ in future when thinking more clearly
## Including for rcopy

dircopy = ($(LSN) && $(touch)) ||  $(rcopy)
ddcopy = ($(LSN) && $(touch)) ||  $(rdcopy)

## Lock and unlock directories to avoid making changes that aren't on the sink path
## git will not track this for you ☹
%.ro:
	chmod -R a-w $*
%.rw:
	chmod -R u+w $*

## File listing and merging
%.ls: %
	ls $* > $@
%.lsd: %
	ls -d $*/* > $@

## Track a directory from the parent directory, using <dir>.md
%.filemerge: %.lsd %.md makestuff/filemerge.pl
	$(PUSH)
	- $(DIFF) $*.md $@
	$(MV) $@ $*.md

# What?
convert = convert $< $@
imageconvert = convert -density 600 -trim $< -quality 100 -sharpen 0x1.0 $@
shell_execute = sh < $@

%.png: %.pdf
	$(convert)

pdfcat = pdfjam --outfile $@ $(filter %.pdf, $^) 

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
Ignore += jekyll.log
serve:
	bundle exec jekyll serve > jekyll.log 2>&1 &

killserve:
	killall jekyll
	sleep 1
	bundle exec jekyll serve &

## Convenience
%.tod: %
	$(CP) $< ~/Downloads

%.var:
	@echo $($*)
