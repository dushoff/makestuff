## Rules for making and linking repo-based directories
## Would be nice to combine this with repos.mk; feels a bit repetitive
## There's also something from the newtalk development named resources.mk
## Should this have a JD-specific name? Should we break out rules that do things from rules that say where things are?

### None of this is working for other people
### Should make the whole Lecture_images thing work recursively
Lecture_images:
	$(LN) $(Drop)/courses/$@ .

my_images:
	$(LN) $(Drop)/$@ .

gitdirs = Birth_death_models Disease_data Latent_incidence_fitting Exponential_figures SIR_model_family fitting_code hybrid_fitting SIR_simulations Generation_distributions WA_Ebola_Outbreak Ebola_sims autorefs dushoff.github.io DHS_overview DHS_convert DHS_downloads Country_lists

## A directory that's already there might have its own local.mk, but if we _clone_ the directory we want to control it

## We had trouble with the first recipe line here spiralling before we added -f.
## That broke the chaining until we added the variable!
$(gitdirs):
	$(MAKE) gitroot=$(gitroot) -f $(gitroot)/makestuff/linkdirs.mk $(gitroot)/$@
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

%_drop: $(Drop)
	$(MAKE) $(Drop)/$*
	$(LNF) $(Drop)/$* $@

$(Drop)/%:
	$(mkdir)

$(Drop):
	$(mkdir)
