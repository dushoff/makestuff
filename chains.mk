
$(foreach pat,$(recipeChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call $(pat)_r,$(s)))\
	)\
)

script_r = %.$(2).$(3).Rout: $(2).R $(1) ; $$(pipeR)
$(foreach pat,$(scriptChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call script_r,$($(pat)_dep),$(s),$(pat)))\
		$(info $(call script_r,$($(pat)_dep),$(s),$(pat)))\
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
