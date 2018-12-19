
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
	$(CP) $(ms)/$@ .

%.dscreen: %
	cd $< && screen -t "$(notdir $<)"

%.vscreen: %.dir
	cd $* && screen -t "$(notdir $*)" bash -cl "vmt"

%.dir:
	cd $(dir $*) && $(MAKE) $(notdir $*)
