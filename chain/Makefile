
target: test.y.rda

run = touch $@ $(@:%.Rout=%.rda)

%.x.Rout: x.R
	$(run)

%.y.Rout: %.x.rda y.R
	$(run)

setup:
	- $(RM) *.Rout *.rda
	touch x.R y.R

%.rda: %.Rout ;

## Help things chain

impmakeR = x y

define impdep
%.$(1).rda: %.$(1).Rout ; 
.PRECIOUS: %.$(1).rda %.$(1).Rout
endef

$(foreach stem,$(impmakeR),$(eval $(call impdep,$(stem))))
