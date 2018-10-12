
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

target.mk:
	$(CP) $(ms)/$@ .
