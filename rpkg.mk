## Much of this is cribbed from McMasterPandemic and glmmTMB
## See makestuff/rpkg.md for explanations
## Need a work-around for being able to sync when we can't build
## built objects are sunk by default because that's how packages and devtools work
## Rebuild to separate dev stuff from shared stuff somehow!

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

pkgall: rpkgbuild/docs rpkgbuild/names rpkgbuild/pkgcheck
quickinstall: rpkgbuild/quick
pkgtest: rpkgbuild/pkgtest

######################################################################

## Startup

.Rbuildignore: 
	cp ../.Rbuildignore $@ || touch $@

DESCRIPTION: 
	cp ../rpkgDescription $@ || touch $@

######################################################################

Sources += DESCRIPTION .Rbuildignore NAMESPACE
Sources += $(wildcard R/*.R)
Sources += $(wildcard man/*.Rd)

######################################################################

## Tracking directory

Ignore += rpkgbuild
rpkgbuild:
	$(mkdir)

######################################################################

rpkgbuild/docs: $(wildcard R/*.R)
	$(MAKE) rpkgbuild
	echo "suppressWarnings(roxygen2::roxygenize(\".\",roclets = c(\"collate\", \"rd\")))" | $(R)
	touch $@

tarball: $(TARBALL)
$(TARBALL): NAMESPACE $(wildcard R/*.*)
	$(R) CMD build .

NAMESPACE: rpkgbuild/names ;
rpkgbuild/names: $(wildcard R/*.R) DESCRIPTION
	$(MAKE) rpkgbuild
	echo "(roxygen2::roxygenize('.',roclets = 'namespace'))" | $(R) \
	|| echo ERROR: FAILED to build NAMESPACE
	touch $@

rpkgbuild/pkgtest: $(TARBALL)
	$(MAKE) rpkgbuild
	echo "devtools::test('.')" | $(R)
	touch $@

rpkgbuild/pkgcheck: rpkgbuild/install
	echo "devtools::check('.')" | $(R)
	touch $@

rpkgbuild/install: $(TARBALL)
	$(MAKE) histclean rpkgbuild
	export NOT_CRAN=true; $(R) CMD INSTALL --preclean $<
	@touch $(TARBALL)
	@touch $@
	@touch rpkgbuild/quick

rpkgbuild/quick: NAMESPACE $(wildcard R/*.*)
	R CMD INSTALL .
	@touch $@

histclean:
	find . \( -name "\.#*" -o -name "*~" -o -name ".Rhistory" \) -exec rm {} \;
