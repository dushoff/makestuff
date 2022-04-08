## Retrofits and hacks

## Bailed on getting the regex syntax right for the $. Watch out?
## Try [$$] if you're bored.
## This is a pain for scripts; see filemerge instead
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
MSEDIT = $(MSEDITOR) $@ || $(EDITOR) $@ || $(VISUAL) $@ || gvim -f $@ || vim $@ || ((echo ERROR: No editor found makestuff/unix.mk && echo set shell MSEDITOR variable && false))
RMR = /bin/rm -rf
LS = /bin/ls
LN = /bin/ln -s
LNF = /bin/ln -fs
MD = mkdir
MKDIR = mkdir
CAT = cat

readonly = chmod a-w $@
RO = chmod a-w 
RW = chmod ug+w
DNE = (! $(LS) $@ > $(null))
LSN = ($(LS) $@ > $(null))

tgz = tar czf $@ $^
zip = zip $@ $^
TGZ = tar czf $@ $^
ZIP = zip $@ $^

null = /dev/null

lscheck = @$(LS) $@ > $(null) || (echo ERROR upstream rule failed to make $@ && false)

hiddenfile = $(dir $1).$(notdir $1)
hide = $(MVF) $1 $(dir $1).$(notdir $1)
unhide = $(MVF) $(dir $1).$(notdir $1) $1
hcopy = $(CPF) $1 $(dir $1).$(notdir $1)
difftouch = diff $1 $(dir $1).$(notdir $1) > /dev/null || touch $1
touch = touch $@

justmakethere = cd $(dir $@) && $(MAKE) $(notdir $@)
makedir = $(MAKE) $(dir $@)
makethere = $(makedir) && cd $(dir $@) && $(MAKE) makestuff && $(MAKE) $(notdir $@)
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
move = $(MV) $< $@
Move = $(MVF) $< $@
hardcopy = $(CPF) $< $@
allcopy =  $(CP) $^ $@
ccrib = $(CP) $(crib)/$@ .
mkdir = $(MD) $@
makedir = cd $(dir $@) && $(MD) $(notdir $@)
cat = $(CAT) /dev/null $^ > $@
catro = $(rm); $(CAT) /dev/null $^ > $@; $(readonly)
ln = $(LN) $< $@
lnf = $(LNF) $< $@
rm = $(RM) $@
pandoc = pandoc -o $@ $<
pandocs = pandoc -s -o $@ $<

######################################################################

## It would be better to have global Drop logic (and to move this rule out of this file)
ifndef Drop
Drop = ~/Dropbox
endif

ifndef DropResource
DropResource = $(Drop)/resources
endif

resDropDir = $(DropResource)/$(notdir $(CURDIR))
$(resDropDir):
	$(mkdir)
resDrop = $(MAKE) $(resDropDir) && $(LNF) $(resDropDir) $@

######################################################################

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
	(ls -d $*/* || ls $*) > $@
index.lsd: .
	ls -d * > $@

define merge_files
	$(PUSH)
	- $(DIFF) $*.md $@
	$(MV) $@ $*.md
endef
 
## Track a directory from the parent directory, using <dir>.md
## index.md for current file
%.filemerge: %.lsd %.md makestuff/filemerge.pl
	$(merge_files)

## WATCH OUT for the -
%.filenames:
	rename "s/[ ,?!-]+/_/g" $*/*.*

%.voice: voice.pl %
	$(PUSH)
	$(MV) $@ $*

# What?
convert = convert $< $@
imageconvert = convert -density 600 -trim $< -quality 100 -sharpen 0x1.0 $@
shell_execute = sh < $@

%.png: %.pdf
	$(convert)

%.image.png: %.pdf
	$(imageconvert)

pdfcat = pdfjam --outfile $@ $(filter %.pdf, $^) 

latexdiff = latexdiff $^ > $@

Ignore += *.ld.tex
%.ld.tex: %.tex
	latexdiff $*.tex.*.oldfile $< > $@

%.pd: %
	$(CP) $< $(pushdir) || $(CP) $< ~/Downloads

%.pdown: %
	$(RM) ~/Downloads/$<
	$(CP) $< ~/Downloads/

%.ldown: %
	cd ~/Downloads && ln -fs $(CURDIR)/$* . && touch $(notdir $*)

%.pushpush: %
	$(CP) $< $(pushdir)
	cd $(pushdir) && make remotesync

%.log: 
	$(RM) $*
	$(MAKE) $* > $*.makelog

%.makelog: %.log ;

%.continue:
	$(MAKE) $* || echo CONTINUING past error in target $*

vimclean:
	perl -wf makestuff/vimclean.pl

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

%.wc: %
	wc $< > $@
