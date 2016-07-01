## Use fancy make-y stuff to make this prettier someday
## Make another file that can download these repos when they are needed!

gitdirs = Birth_death_models Disease_data Latent_incidence_fitting Exponential_figures SIR_model_family talkfigs fitting_code hybrid_fitting SIR_simulations

dropdirs = Lecture_images htmp curves tbincome

rdirs = $(gitdirs) $(dropdirs)

$(gitdirs):
	$(LN) $(gitroot)/$@ .

Lecture_images:
	$(LN) $(Drop)/courses/$@ .

## Developing on Taiwan MRT. Get rid of this when you can
htmp:
	$(LN) $(Drop)/ICI3D/WorkingWiki-export/Heterogeneity_lecture $@

curves:
	$(LN) $(Drop)/ICI3D/WorkingWiki-export/Endemic_curves_with_heterogeneity $@

tbincome:
	$(LN) $(Drop)/ICI3D/WorkingWiki-export/TB_and_income $@

images:
	$(LN) $(Drop)/

maketouch = cd $$(dir $$@) && $$(MAKE) $$* && touch $$*

define dirmake
$(1)/%: $(1)
	$(maketouch)
endef

# $(info $(call dirmake,Lecture_images))
# $(eval $(call dirmake,Lecture_images))

$(foreach dir,$(rdirs),$(eval $(call dirmake,$(dir))))

