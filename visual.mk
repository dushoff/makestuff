
## Make things appear; some of it feels pretty Dushoff-specific
## Need to transition to $(target)-based rules (no $<)

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

optarget:
	$(MAKE) $(target:%=%.pdf.op) || $(MAKE) $(target:%=%.op)

pushtarget:
	$(MAKE) $<.pd

dtarget:
	$(MAKE) $(target:%=%.ldown)

olddtarget:
	$(MAKE) pushdir=~/Downloads/ pushtarget

## This was made for texdeps; how does it work for texi? or is it needed?
deptarget:
	$(MAKE) $(target:.pdf=.deps)

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
