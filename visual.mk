## Make things appear; some of it feels pretty Dushoff-specific

pngtarget: 
	$(MAKE) $<.png
	$(MAKE) $<.png.go

pdftarget:
	$(MAKE) $<
	($(MAKE) $<.pdf && $(MAKE) $<.pdf.go) || $(MAKE)  $<.go

vtarget:
	$(MAKE) $<.go

acrtarget:
	$(MAKE) $<.acr

gptarget:
	$(MAKE) $<.pdf.op || $(MAKE) $<.op

pushtarget:
	$(MAKE) $<.pd

dtarget:
	$(MAKE) pushdir=~/Downloads/ pushtarget

## The $< paradigm is stupid; let's try something else 2021 Feb 02 (Tue)
deptarget:
	$(MAKE) $(target:.pdf=.deps)

doctarget:
	$(MAKE) $(target:%=%.docs)

target.mk:
	$(CP) makestuff/newtarget.mk $@

## 
%.dscreen: %.dir
	cd $* && screen -t "$(notdir $*)"

## open directory in a screen window (for running things)
## meant to be called from within screen (otherwise makes a new one)
## startscreen part is clumsy
%.rscreen: %.dir
	cd $(dir $*) && $(MAKE) "$(notdir $*)" 
	- cd $* && $(MAKE) startscreen
	cd $* && screen -t "$(notdir $*)"

## do the above and open a vim_session
%.vscreen: %.dir
	cd $(dir $*) && $(MAKE) "$(notdir $*)" 
	- cd $* && $(MAKE) vimclean
	cd $* && screen -t "$*" bash -cl "vvs"

## Old-style vscreen (short names)
%.svscreen: %.dir
	cd $(dir $*) && $(MAKE) "$(notdir $*)" 
	cd $* && screen -t "$(notdir $*)" bash -cl "vvs"

%.dir:
	cd $(dir $*) && $(MAKE) $(notdir $*)
