
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

## Not working, apparently
deptarget:
	$(MAKE) $(<:.pdf=.deps)

target.mk:
	$(CP) $(ms)/$@ .
