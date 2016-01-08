# Unix
MVF = /bin/mv -f
MV = /bin/mv
CP = /bin/cp
CPF = /bin/cp -f
DIFF = diff
EDIT = gvim
RMR = /bin/rm -rf
LN = /bin/ln -s
TGZ = tar czf $@ $^
MD = mkdir
CAT = cat
ZIP = zip $@ $^

# Generic
link = $(LN) $< $@
copy = $(CP) $< $@
ccrib = $(CP) $(crib)/$@ .
mkdir = $(MD) $@
cat = $(CAT) $^ > $@

# What?
convert = convert $< $@
shell_execute = sh < $@
