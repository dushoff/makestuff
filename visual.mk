## Make things appear; some of it feels pretty Dushoff-specific
## Need to transition to $(target)-based rules (no $<)
## See visual.md for ideas about updating startscreen/rscreen/vscreen paradigm

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
	cd $* && screen -t "$*"

%.rscreen:
	-cd $* && $(MAKE) startscreen 
	-cd $* && screen -t "$(notdir $*)"

%.vscreen: | %
	- cd $* && $(MAKE) vimclean
	cd $* && screen -t "$*" bash -cl "vvs"

%.dir:
	cd $(dir $*) && $(MAKE) $(notdir $*)
