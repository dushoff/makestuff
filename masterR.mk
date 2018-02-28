
%.master.R: %.Rout
	- /bin/rm -rf dotdir
	$(MAKE) dotdir.localdir
	cd dotdir && $(MAKE) makestuff && $(MAKE) -ndr $*.Rout > make.log
	perl -wf $(ms)/masterR.pl dotdir/make.log > $@

Ignore += *.master.mk
%.master.mk: %.master.R
	perl -wf $(ms)/masterRfiles.pl $< > $@
	$(MAKE) -f $@ -f Makefile runs

%.masterR: %.master.R %.master.mk ;
