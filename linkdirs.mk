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

## 2018 May 23 (Wed): get rid of old gitroot stuff
## This causes spiralling
$(gitdirs):
	$(MAKE) -f makestuff/linkdirs.mk ./$@

$(gitroot)/local.mk: ;

$(gitroot)/Makefile: ;

$(gitroot)/%:
	cd $(gitroot) && $(MAKE) -f makestuff/repos.mk $*
	-cp local.mk $@/
	echo "gitroot=$$PWD" >> $@/local.mk
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

## A problem here. If we use dependencies it will re-link; if we use recursive make we can have loops
.PRECIOUS: %_drop
%_drop:
	$(MAKE) $(Drop)
	$(MAKE) $(Drop)/$*
	$(LNF) $(Drop)/$* $@

$(Drop)/%: 
	-$(mkdir)

$(Drop):
	-$(mkdir)
