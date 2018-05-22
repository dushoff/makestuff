
%.hybridignore: 
	cd $* && $(MAKE) Makefile.ignore && $(MAKE) hybridignore

%.cloneignore: 
	cd $* && $(MAKE) Makefile.ignore && $(MAKE) cloneignore

%.modignore: 
	cd $* && $(MAKE) Makefile.ignore && $(MAKE) modignore

Makefile.ignore:
	perl -pi -e 's/(Sources.*).gitignore/$$1.ignore/' Makefile
	-git rm .gitignore

## Hybridizing and cleaning up; some of these rules should be phased out
hybridignore: $(clonedirs:%=%.hybridignore) $(mdirs:%=%.hybridignore);
cloneignore: $(clonedirs:%=%.cloneignore) ;
modignore: $(mdirs:%=%.modignore) ;

