
## Make things appear; some of it feels pretty Dushoff-specific

pngtarget: 
	$(MAKE) $<.png
	$(MAKE) $<.png.go

pdftarget:
	$(MAKE) $<.pdf
	$(MAKE) $<.pdf.go

vtarget:
	$(MAKE) $<.go

acrtarget:
	$(MAKE) $<.acr

gptarget:
	$(MAKE) $<.gp

pushtarget:
	$(MAKE) $<.pd

dtarget:
	$(MAKE) pushdir=~/Downloads/ pushtarget

## Not tested; could also try adding deptarget: $(target) and using $<
deptarget:
	$(MAKE) $(target:.pdf=.deps)

target.mk:
	$(CP) makestuff/$@ .

%.dscreen: %.dir
	cd $* && screen -t "$(notdir $*)"

frogs:
	@echo $(notdir trace)
	@echo $(dir trace)

%.vscreen: %.dir
	cd $(dir $*) && $(MAKE) "$(notdir $*)" 
	cd $* && screen -t "$(notdir $*)" bash -cl "vmt"

%.dir:
	cd $(dir $*) && $(MAKE) $(notdir $*)
