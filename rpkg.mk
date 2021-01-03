## Much of this is cribbed from McMasterPandemic and glmmTMB

R = R --vanilla
PACKAGE = rRlinks
VERSION := $(PACKAGE)_$(shell sed -n '/^Version: /s///p' ./DESCRIPTION)
TARBALL := $(VERSION).tar.gz

Ignore += $(TARBALL)

## VERSION.var:

Ignore += *.built

pkgall: clean docs.built names.built pkgcheck.built

docs.built: $(wildcard R/*.R)
	echo "suppressWarnings(roxygen2::roxygenize(\".\",roclets = c(\"collate\", \"rd\")))" | $(R)
	touch $@

.Rbuildignore: 
	cp ../.Rbuildignore $@ || touch $@

DESCRIPTION: 
	cp ../rpkgDescription $@ || touch $@

NAMESPACE: names.built ;
names.built: $(wildcard R/*.R)
	echo "(roxygen2::roxygenize('.',roclets = 'namespace'))" | $(R)
	touch $@

pkgtest.built: $(TARBALL)
	echo "devtools::test('.')" | $(R)
	touch $@

pkgcheck.built: install.built
	echo "devtools::check('.')" | $(R)
	touch $@

clean:
	find . \( -name "\.#*" -o -name "*~" -o -name ".Rhistory" \) -exec rm {} \;

$(TARBALL): NAMESPACE $(wildcard R/*.*)
	$(R) CMD build .

install.built: $(TARBALL)
	export NOT_CRAN=true; $(R) CMD INSTALL --preclean $<
	@touch $@

