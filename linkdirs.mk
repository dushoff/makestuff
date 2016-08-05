## Rules for making and linking repo-based directories
## Would be nice to combine this with repos.mk; feels a bit repetitive
gitdirs = Birth_death_models Disease_data Latent_incidence_fitting Exponential_figures SIR_model_family fitting_code hybrid_fitting SIR_simulations Generation_distributions WA_Ebola_Outbreak Ebola_sims

## A directory that's already there might have its own local.mk, but if we make the directory, we want to control it
$(gitdirs):
	cd $(gitroot) && $(MAKE) -f makestuff/repos.mk $@
	$(LNF) $(gitroot)/$@ .
	cp local.mk $@/
	echo "gitroot=../" >> $@/local.mk
	cd $@ && $(MAKE) Makefile

## To make things in these directories;
#### make the directory
#### go there and make and touch
maketouch = cd $$(dir $$@) && $$(MAKE) $$* && touch $$*
define dirmake
$(1)/%: $(1)
	$(maketouch)
endef

$(foreach dir,$(gitdirs),$(eval $(call dirmake,$(dir))))
