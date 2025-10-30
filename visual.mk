## Make things appear; some of it feels pretty Dushoff-specific
## Need to transition to $(target)-based rules (no $<)

target.%:
	$(MAKE) $(target:%=%.pdf.$*) || $(MAKE) $(target:%=%.$*)

ttarget.%:
	$(MAKE) $(target:%=%.$*)

## What is any of the stuff below? Target stuff should be simplified, and maybe put in a better-named place. Except that visual is in every single goshdarned Makefile 2025 Oct 30 (Thu)

pngtarget: 
	$(MAKE) $<.png
	$(MAKE) $<.png.go

pdftarget:
	$(MAKE) $<
	($(MAKE) $<.pdf && ls $<.pdf && $(MAKE) $<.pdf.go) || $(MAKE) $<.go

vtarget:
	$(MAKE) $<.go

acrtarget:
	$(MAKE) $<.acr

gptarget:
	$(MAKE) $<.op

optarget:
	$(MAKE) $(target:%=%.pdf.op) || $(MAKE) $(target:%=%.op)

finaltarget: 
	$(MAKE) $(target:%=%.final)

pushtarget:
	$(MAKE) $<.pd

dtarget:
	$(MAKE) $(target:%=%.pdf.ldown) || $(MAKE) $(target:%=%.ldown)

hardtarget:
	$(MAKE) $(target:%=%.pdf.pdown) || $(MAKE) $(target:%=%.pdown)

## The $< paradigm is stupid; let's try something else 2021 Feb 02 (Tue)
doctarget:
	$(MAKE) docpdftarget || $(MAKE) docsimptarget

docpdftarget:
	$(MAKE) $(target:%=%.pdf.docs)

docsimptarget:
	$(MAKE) $(target:%=%.docs)

rmtarget:
	- $(call hide,  $(target))
	$(MAKE) $(target)

target.mk:
	$(CP) makestuff/newtarget.mk $@

## 
%.dscreen: %.dir
	cd $* && screen -t "$(notdir $*)"

######################################################################

## screening stuff (seems like listdir stuff, but presumably predates it)

## open directory in a screen window (for running things)
## meant to be called from within screen (otherwise makes a new one)
%.newscreen: %.dir
	cd $* && screen -t "$(notdir $*)"

%.rscreen:
	-cd $* && $(MAKE) startscreen 
	-cd $* && screen -t "$(notdir $*)"

## Beefed up first recipe for MMED25; maybe this rule should go into screendir Makefile instead?
%.vscreen: | %
	- $(MAKE) $*/Makefile && (cd $* && $(MAKE) Makefile) || $(MAKE) $*.mkfile
	- cd $* && ($(MAKE) vimclean || true)
	cd $* && screen -t "$(notdir $*)" bash -cl "vvs"

%.dir:
	cd $(dir $*) && $(MAKE) $(notdir $*)
