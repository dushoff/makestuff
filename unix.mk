# Unix
MVF = /bin/mv -f
MV = /bin/mv
CP = /bin/cp
CPF = /bin/cp -f
DIFF = diff
EDIT = gvim
RMR = /bin/rm -rf
LN = /bin/ln -s
LNF = /bin/ln -fs
TGZ = tar czf $@ $^
MD = mkdir
CAT = cat
ZIP = zip $@ $^
readonly = chmod a-w $@
RO = chmod a-w $@

hide = $(MVF) $1 $(dir $1).$(notdir $1)
hcopy = $(CPF) $1 $(dir $1).$(notdir $1)
difftouch = diff $1 $(dir $1).$(notdir $1) > /dev/null || touch $1

# Generic (vars that use the ones above)
link = $(LN) $< $@
forcelink = $(LNF) $< $@
copy = $(CP) $< $@
ccrib = $(CP) $(crib)/$@ .
mkdir = $(MD) $@
cat = $(CAT) $^ > $@
ln = $(LN) $< $@
lnf = $(LNF) $< $@

# What?
convert = convert $< $@
imageconvert = convert -density 300 -trim $< -quality 100 -sharpen 0x1.0 $@
shell_execute = sh < $@
# pdfcat = pdftk $(filter %.pdf, $^) cat output $@
pdfcat = pdfjoin --outfile $@ $(filter %.pdf, $^) 

%.push: %
	$(CP) $< $(pushdir)
