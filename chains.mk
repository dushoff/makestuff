
## Gen 1 families

$(foreach pat,$(recipeChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call $(pat)_r,$(s)))\
	)\
)

## scriptChain
script_r = %.$(2).$(3).Rout: $(2).R $(1) ; $$(pipeR)
$(foreach pat,$(scriptChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call script_r,$($(pat)_dep),$(s),$(pat)))\
	)\
)

## parseChain
parse_r = %.$(2).$(3).Rout: $(3).R $(1) ; $$(pipeR)
$(foreach pat,$(parseChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call parse_r,$($(pat)_dep),$(s),$(pat)))\
	)\
)

pipeRimplicit += $(recipeChain) $(scriptChain) $(parseChain)

######################################################################

## Gen 1 families

$(foreach pat,$(recipeChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call $(pat)_r,$(s)))\
	)\
)

## scriptChain
script_r = %.$(2).$(3).Rout: $(2).R $(1) ; $$(pipeR)
$(foreach pat,$(scriptChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call script_r,$($(pat)_dep),$(s),$(pat)))\
	)\
)

## parseChain
parse_r = %.$(2).$(3).Rout: $(3).R $(1) ; $$(pipeR)
$(foreach pat,$(parseChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call parse_r,$($(pat)_dep),$(s),$(pat)))\
	)\
)

pipeRimplicit += $(recipeChain) $(scriptChain) $(parseChain)

######################################################################

## Gen 2 families
## Call recipes with family; example; dep

## scriptStep
scriptStep_r = %.$(2).$(1).Rout: $(2).R $(3) ; $$(pipeR)
$(foreach fam,$(scriptStep),\
	$(foreach ex, $($(fam)),\
		$(eval $(call scriptStep_r,$(fam),$(ex),$($(fam)_dep)))\
	)\
)

## scriptStep take a step, and add script name and family name to root
## Question: would it be better to use a suffix for the script name?
## e.g. use borneo.data.R instead of borneo.R to make %.borneo.data.Rout?
## Could we give users the option?
scriptStep_r = %.$(2).$(1).Rout: $(2).R $(3) ; $$(pipeR)
$(foreach fam,$(scriptStep),\
	$(foreach ex, $($(fam)),\
		$(eval $(call scriptStep_r,$(fam),$(ex),$($(fam)_dep)))\
	)\
)

## scriptLink ## Not implemented; this one should be modular I guess
scriptLink_r = %.$(2).Rout: $(2).R $(3) ; $$(pipeR)
scriptLink_longr = %.$(2).Rout: $(2).R $(3) ; $$(pipeR)

pipeRimplicit += $(scriptStep) $(scriptLink)

######################################################################

## New paradigm: right in pipeR.mk?

## chainLink; like scriptStep. Main difference is that script should have extension (like borneo.data.R above)

## Note that different kinds of script steps should not be needed? I guess there's the problem with calling the same rule over again? How is that dealt with in Gen 1?
## It's not! It seemed to work, but doesn't actually.

## Also, do we want a paradigm for the first step? Seems maybe unnecessary.
