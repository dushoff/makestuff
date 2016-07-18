## Use fancy make-y stuff to make this prettier someday
## Make another file that can download these repos when they are needed!

gitdirs = Birth_death_models Disease_data Latent_incidence_fitting Exponential_figures SIR_model_family fitting_code hybrid_fitting SIR_simulations Generation_distributions WA_Ebola_Outbreak Ebola_sims

dropdirs = Lecture_images htmp curves tbincome HIV_model_data my_images

# This is probably a legacy directory. Some of the content should be moved to statistics_lectures
gitdirs += ICI3D

# These should not be Dropbox directories; try to clean up
dropdirs += htmp curves tbincome HIV_model_data CI_diagrams Philosophy_lecture

## This is deprecated for my_images (I think)
dropdirs += talkfigs 

rdirs = $(gitdirs) $(dropdirs)

githomes = $(gitdirs:%=$(gitroot)/%)
$(githomes):
	cd $(gitroot) && $(MAKE) -f makestuff/repos.mk $(notdir $@)

$(gitdirs):
	$(MAKE) $(gitroot)/$@
	$(LNF) $(gitroot)/$@ .
	echo "gitroot=../" > $@/local.mk
	cd $@ && $(MAKE) Makefile

Lecture_images:
	$(LN) $(Drop)/courses/$@ .

my_images:
	$(LN) $(Drop)/$@ .

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

CI_diagrams:
	$(LN) $(Drop)/ICI3D/WorkingWiki-export/CI_diagrams $@

Philosophy_lecture:
	$(LN) $(Drop)/ICI3D/WorkingWiki-export/Philosophy_lecture $@

## Need to talk to Pulliam (or Williams) about githubbing this. Or share it on Dropbox?
HIV_model_data:
	$(LN) $(Drop)/ICI3D/$@ .

maketouch = cd $$(dir $$@) && $$(MAKE) $$* && touch $$*

define dirmake
$(1)/%: $(1)
	$(maketouch)
endef

# $(info $(call dirmake,Lecture_images))
# $(eval $(call dirmake,Lecture_images))

$(foreach dir,$(rdirs),$(eval $(call dirmake,$(dir))))
