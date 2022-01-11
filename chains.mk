scoop = $(foreach pat,$(recipeChain),\
	$($(pat)_r)\
)

$(foreach pat,$(recipeChain),\
	$(foreach s, $($(pat)),\
		$(eval $(call $(pat)_r,$(s)))\
	)\
)
