## Rules for making and linking repo-based directories
## Would be nice to combine this with repos.mk; feels a bit repetitive
## There's also something from the newtalk development named resources.mk
## Should this have a JD-specific name? Should we break out rules that do shit from rules that say where things are?

gitdirs = Birth_death_models Disease_data Latent_incidence_fitting Exponential_figures SIR_model_family fitting_code hybrid_fitting SIR_simulations Generation_distributions WA_Ebola_Outbreak Ebola_sims autorefs dushoff.github.io

## A directory that's already there might have its own local.mk, but if we make the directory, we want to control it
## If we _clone_ the directory we want to control it; but not if we just find it.
$(gitdirs):
	$(MAKE) $(gitroot)/$@
	$(LNF) $(gitroot)/$@ .

$(gitroot)/local.mk: ;

$(gitroot)/%:
	cd $(gitroot) && $(MAKE) -f makestuff/repos.mk $*
	-cp local.mk $@/
	echo "gitroot=../" >> $@/local.mk
	cd $@ && $(MAKE) Makefile

## To make things in these directories;
#### make the directory
#### go there and make and touch
maketouch = cd $$(dir $$@) && $$(MAKE) $$* && touch $$*
define dirmake
$(1)/%.mk: ;
$(1)/%: $(1)
	$(maketouch)
endef

$(foreach dir,$(gitdirs),$(eval $(call dirmake,$(dir))))
