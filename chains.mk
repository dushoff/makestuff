scoop = $(foreach pat,$(recipeChain),\
	$($(pat)_r)\
)

$(foreach pat,$(recipeChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call $(pat)_r,$(s)))\
	)\
)

script_r = %.$(2).$(3).Rout: $(2).R $(1) ; $$(pipeR)
$(foreach pat,$(scriptChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call script_r,$($(pat)_dep),$(s),$(pat)))\
	)\
)

pipeRimplicit += $(recipeChain) $(scriptChain)
