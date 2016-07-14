## Use fancy make-y stuff to make this prettier someday
## Make another file that can download these repos when they are needed!

gitdirs = Birth_death_models Disease_data Latent_incidence_fitting Exponential_figures SIR_model_family fitting_code hybrid_fitting SIR_simulations Generation_distributions WA_Ebola_Outbreak Ebola_sims

githomes = $(gitdirs:%=$(gitroot)/%)

dropdirs = Lecture_images htmp curves tbincome talkfigs HIV_model_data

rdirs = $(gitdirs) $(dropdirs)

$(githomes):
	cd $(gitroot) && $(MAKE) -f makestuff/repos.mk $(notdir $@)

$(gitdirs):
	$(MAKE) $(gitroot)/$@
	$(LNF) $(gitroot)/$@ .
	echo "gitroot=../" > $@/local.mk
	cd $@ && $(MAKE) Makefile

Lecture_images:
	$(LN) $(Drop)/courses/$@ .

## Developing on Taiwan MRT. Get rid of this when you can
htmp:
	$(LN) $(Drop)/ICI3D/WorkingWiki-export/Heterogeneity_lecture $@

HIV_model_data: 
	$(LN) $(Drop)/ICI3D/$@ .

curves:
	$(LN) $(Drop)/ICI3D/WorkingWiki-export/Endemic_curves_with_heterogeneity $@

tbincome:
	$(LN) $(Drop)/ICI3D/WorkingWiki-export/TB_and_income $@

talkfigs:
	$(LN) $(Drop)/$@ .

maketouch = cd $$(dir $$@) && $$(MAKE) $$* && touch $$*

define dirmake
$(1)/%: $(1)
	$(maketouch)
endef

# $(info $(call dirmake,Lecture_images))
# $(eval $(call dirmake,Lecture_images))

$(foreach dir,$(rdirs),$(eval $(call dirmake,$(dir))))

