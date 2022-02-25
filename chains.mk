
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

## scriptLink
scriptLink_r = %.$(2).Rout: $(2).R $(3) ; $$(pipeR)
scriptLink_longr = %.$(2).Rout: $(2).R $(3) ; $$(pipeR)

pipeRimplicit += $(scriptStep) $(scriptLink)

######################################################################
