## Fake dependency to avoid looping (since master.R is a source)

## Make a master.R script, but not run files (safer to do after making .Rout)
%.masterscript: 
	$(MAKE) dotdir.localdir
	-cd dotdir && $(MAKE) makestuff
	cd dotdir && $(MAKE) -ndr $*.Rout > make.log
	perl -wf makestuff/masterR.pl dotdir/make.log > $*.master.R

## Make a file that creates and pushes run files
## We could probably do a lot more modularization here
Ignore += *.master.mk
%.master.mk: %.masterscript
	perl -wf makestuff/masterRfiles.pl $(<:.masterscript=.master.R) > $@
	$(MAKE) -f $@ -f Makefile runs
	$(MAKE) pushruns

%.masterR: %.Rout %.masterscript %.master.mk ;

pushruns:
	git add $(wildcard *.run.r)
	touch Makefile
