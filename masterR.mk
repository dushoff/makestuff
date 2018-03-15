## Fake dependency to avoid looping (since master.R is a source)
%.masterscript: %.Rout
	- /bin/rm -rf dotdir
	$(MAKE) dotdir.localdir
	-cd dotdir && $(MAKE) makestuff
	cd dotdir && $(MAKE) -ndr $*.Rout > make.log
	perl -wf $(ms)/masterR.pl dotdir/make.log > $*.master.R

Ignore += *.master.mk
%.master.mk: %.masterscript
	perl -wf $(ms)/masterRfiles.pl $(<:.masterscript=.master.R) > $@
	$(MAKE) -f $@ -f Makefile runs

%.masterR: %.masterscript %.master.mk ;

pushruns:
	git add $(wildcard *.run.r)
	touch Makefile
