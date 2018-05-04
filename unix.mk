# Unix
MVF = /bin/mv -f
MV = /bin/mv
CP = /bin/cp
CPF = /bin/cp -f
DIFF = diff
EDIT = gvim -f
RMR = /bin/rm -rf
LN = /bin/ln -s
LNF = /bin/ln -fs
TGZ = tar czf $@ $^
MD = mkdir
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
linkdir = ls $(dir)/$@ > $(null) && $(LNF) $(dir)/$@ .
linkdirname = ls $(dir) > $(null) && $(LNF) $(dir) $@ 

forcelink = $(LNF) $< $@
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
# pdfcat = pdftk $(filter %.pdf, $^) cat output $@
pdfcat = pdfjoin --outfile $@ $(filter %.pdf, $^) 

%.pd: %
	$(CP) $< $(pushdir)

%.pushpush: %
	$(CP) $< $(pushdir)
	cd $(pushdir) && make remotesync

%.log: 
	$(RM) $*
	$(MAKE) $* > $*.makelog

%.makelog: %.log ;

## Confused by this now
serve:
	bundle exec jekyll serve &

killserve:
	killall jekyll
	sleep 1
	bundle exec jekyll serve &
