## Retrofits and hacks

# Unix basics (this is a hodge-podge of spelling conventions ☹)
MVF = /bin/mv -f
MV = /bin/mv
CP = /bin/cp
CPF = /bin/cp -f
CPR = /bin/cp -rf
DIFF = diff

MSEDIT = nano $@ || $(MSEDITOR) $@ || $(EDITOR) $@ || $(VISUAL) $@ || $(VEDIT) $@ || gvim -f $@ || nano $@ || vim $@ || ((echo ERROR: No editor found makestuff/unix.mk && echo set shell MSEDITOR variable && false))
RMR = /bin/rm -rf
RMRF = /bin/rm -rf
LS = /bin/ls
LN = /bin/ln -s
LNF = /bin/ln -fs
MD = mkdir
MKDIR = mkdir
CAT = cat

## Use RO and RW as components; fixing this back to original 2025 Oct 25 (Sat)
RO = chmod a-w
RW = chmod ug+w
readonly = $(RO) $@
readwrite = $(RW) $@

DNE = (! $(LS) $@ > $(null))
LSN = ($(LS) $@ > $(null))

tgz = tar czf $@ $^
zipin = zip $@ $?
zip = $(RM) $@ && zip $@ $^
TGZ = tar czf $@ $^
ZIP = $(zip)

touch = touch $@

null = /dev/null

lscheck = @$(LS) $@ > $(null) || (echo ERROR upstream rule failed to make $@ && false)

lstouch = @$(LS) $@ > $(null) || ((echo ERROR upstream rule failed to make $@ && false) && touch $@)

impcheck = @($(LS) $$@ > $(null) || (echo ERROR upstream rule failed to make $$@ && false)) && touch $$@

hiddenfile = $(dir $1).$(notdir $1)
hide = $(MVF) $1 $(dir $1).$(notdir $1)
unhide = $(MVF) $(dir $1).$(notdir $1) $1
hiddentarget = $(call hiddenfile, $@)
unhidetarget = $(call unhide, $@)
hcopy = $(CPF) $1 $(dir $1).$(notdir $1)
difftouch = diff $1 $(dir $1).$(notdir $1) > /dev/null || touch $1

## makethere is behaving weird 2022 Apr 29 (Fri)
## makestuffthere, too 2022 Aug 04 (Thu)
makethere = $(makedir) && cd $(dir $@) && $(MAKE) makestuff && $(MAKE) $(notdir $@)
makedir = $(MAKE) $(dir $@)
justmakethere = cd $(dir $@) && $(MAKE) $(notdir $@)
makestuffthere = cd $(dir $@) && $(MAKE) makestuff && $(MAKE) $(notdir $@)

Ignore += *.checkfile
.PRECIOUS: %.checkfile
%.checkfile: ; touch $@ 
checkfile = $(call hiddenfile,  $@.checkfile)
setcheckfile = touch $(checkfile) && false

diff = $(DIFF) $^ > $@

## Need to upgrade use $(notdir … to handle case where it's not in the cwd
## This is tricky because ln is also weird about what directory it's in
# Generic (vars that use the ones above)
linkdir = ls $(dir)/$@ > $(null) && $(LNF) $(dir)/$@ .
linkdirname = ls $(dir) > $(null) && $(LNF) $(dir) $@ 
linkexisting = ls $< > /dev/null && $(ln)

linkelsewhere = cd $(dir $@) && $(LNF) $(CURDIR)/$< $(notdir $@) 

## This will make directory if it doesn't exist
## Possibly good for shared projects. Problematic if central user makes two 
## redundant dropboxes because of sync problems
alwayslinkdir = (ls $(dir)/$@ > $(null) || $(MD) $(dir)/$@) && $(LNF) $(dir)/$@ .
alwayslinkdirname = (ls $(dir) > $(null) || $(MD) $(dir)) && $(LNF) $(dir) $@

forcelink = $(LNF) $< $@
rcopy = $(CPR) $< $@
rdcopy = $(CPR) $(dir) $@
copy = $(CP) $< $@
pcopy = $(CP) $(word 1, $|) $@

hardcopy = $(CPF) $< $@
allcopy =  $(CP) $^ $@

move = $(MV) $< $@
Move = $(MVF) $< $@
ccrib = $(CP) $(crib)/$@ .
mkdir = $(MD) $@
makedir = cd $(dir $@) && $(MD) $(notdir $@)
cat = $(CAT) /dev/null $^ > $@
catro = $(rm); $(CAT) /dev/null $^ > $@; $(readonly)
ln = $(LN) $< $@
link = $(ln)
lnf = $(LNF) $< $@
forcelink = $(lnf)
lnp = $(LNF) $| $@
rm = $(RM) $@
pandoc = pandoc -o $@ $<
pandocs = pandoc -s -o $@ $<

## oocopy seems just lazy, use pcopy
pcopy = $(CP) $(word 1, $|) $@
oocopy = $(CP) $| $@

######################################################################

## It would be better to have global Drop logic (and to move this rule out of this file)
Drop ?= ~/Dropbox

DropResource ?= $(Drop)/resources

resDropDir ?= $(DropResource)/$(notdir $(CURDIR))
$(resDropDir):
	$(mkdir)

Ignore += dropstuff
dropstuff: | $(resDropDir)
	$(lnp)

######################################################################

## A newer effort which I'm suddenly abandoning in favor of above; merge ideas?
$(resourcedir):
	$(mkdir)
resources: | $(resourcedir)

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

PUSH ?= @(echo "PUSH not defined" & false)

## File listing and merging
%.ls: %
	ls $* > $@
%.lsd: | %
	(ls -d $*/* || ls $*) > $@
Ignore += index.lsd
index.lsd: .
	ls -d * > $@

define merge_files
	@$(RM) *.oldfile
	@$(PUSH)
	@($(DIFF) $(word 2, $^) $@ && $(MV) $@ $(word 2, $^)) \
	|| ($(MV) $@ $(word 2, $^) && false)
	@! (grep MISSING $(word 2, $^))
endef
 
## Track a directory from the parent directory, using <dir>.md
## index.md for current file
## Testing; can filemerge use md or mkd alternatively? Which one is prioritized? 2023 Mar 10 (Fri)
%.filemerge: %.lsd %.md makestuff/filemerge.pl
	$(merge_files)

%.filemerge: %.lsd %.mkd makestuff/filemerge.pl
	$(merge_files)

## WATCH OUT for the -
%.filenames:
	rename "s/[()& ,?!-]+/_/g" $*/*.*
%.fileversions:
	cd $* && rename -f "s/ *\([0-9]\)//" *\([0-9]\).*

## Temporary 2024 Sep 10 (Tue)
%.qfiles:
	rename "s/[()& ,?!-]+/_QQ_/g" $*/*.*

%.voice: voice.pl %
	$(PUSH)
	$(MV) $@ $*

# What?
convert = convert $< $@
imageconvert = convert -density 600 -trim $< -quality 100 -sharpen 0x1.0 $@
shell_execute = sh < $@

%.cnv.png: %.pdf
	$(convert)

%.image.png: %.pdf
	$(imageconvert)

## dog is heavier, but preserves links?
pdfcat = pdfjam --outfile $@ $(filter %.pdf, $^) 
pdfdog = pdftk $(filter %.pdf, $^) cat output $@

latexdiff = latexdiff $^ $| > $@

Ignore += *.ld.tex
%.ld.tex: %.tex
	latexdiff $*.tex.*.oldfile $< > $@

%.pd: % | $(pushdir)
	$(CP) $< $(pushdir)

pushmake:
	cd $(dir $(pushdir)) && mkdir $(notdir $(pushdir))

%.pdown: %
	$(RM) ~/Downloads/$<
	$(CP) $< ~/Downloads/

%.ldown: %
	cd ~/Downloads && ln -fs $(CURDIR)/$* . && touch $(notdir $*)

%.pushpush: %
	$(CP) $< $(pushdir)
	cd $(pushdir) && make remotesync

%.rmk: 
	$(RM) $*
	$(MAKE) $*

## Changed to not conflict with makegraph 2025 Feb 24 (Mon)
%.make.log: 
	$(RM) $*
	$(MAKE) $* > $*.makelog

%.makelog: %.make.log ;

%.continue:
	$(MAKE) $* || echo CONTINUING past error in target $*

vimclean:
	perl -wf makestuff/vimclean.pl

## Jekyll stuff
Ignore += jekyll.log
serve: | Gemfile
	bundle exec jekyll serve > jekyll.log 2>&1 &

Gemfile:
	@echo Gemfile not found && false

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
