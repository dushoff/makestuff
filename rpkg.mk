## Much of this is cribbed from McMasterPandemic and glmmTMB

######################################################################

## Names and variables

R = R --vanilla
PACKAGE = $(shell sed -n '/^Package: /s///p' ./DESCRIPTION)
VERSION := $(PACKAGE)_$(shell sed -n '/^Version: /s///p' ./DESCRIPTION)
TARBALL := $(VERSION).tar.gz

Ignore += $(TARBALL)

## VERSION.var:

######################################################################

## Shortcuts

pkgall: clean rpkgbuild/docs rpkgbuild/names rpkgbuild/pkgcheck
dinst: rpkgbuild/quick

######################################################################

## Startup

.Rbuildignore: 
	cp ../.Rbuildignore $@ || touch $@

DESCRIPTION: 
	cp ../rpkgDescription $@ || touch $@

######################################################################

## Tracking directory

Ignore += rpkgbuild/
rpkgbuild:
	$(mkdir)

######################################################################

rpkgbuild/docs: $(wildcard R/*.R)
	echo "suppressWarnings(roxygen2::roxygenize(\".\",roclets = c(\"collate\", \"rd\")))" | $(R)
	touch $@

$(TARBALL): NAMESPACE $(wildcard R/*.*)
	$(R) CMD build .

NAMESPACE: rpkgbuild/names ;
rpkgbuild/names: $(wildcard R/*.R)
	$(MAKE) rpkgbuild
	echo "(roxygen2::roxygenize('.',roclets = 'namespace'))" | $(R)
	touch $@

rpkgbuild/pkgtest: $(TARBALL)
	echo "devtools::test('.')" | $(R)
	touch $@

rpkgbuild/pkgcheck: rpkgbuild/install
	echo "devtools::check('.')" | $(R)
	touch $@

rpkgbuild/install: $(TARBALL)
	export NOT_CRAN=true; $(R) CMD INSTALL --preclean $<
	@touch $@
	@touch rpkgbuild/quick

rpkgbuild/quick: NAMESPACE $(wildcard R/*.*)
	R CMD INSTALL .
	@touch $@

clean:
	find . \( -name "\.#*" -o -name "*~" -o -name ".Rhistory" \) -exec rm {} \;
