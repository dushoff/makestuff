## Use fancy make-y stuff to make this prettier someday
## Make another file that can download these repos when they are needed!

gitdirs = Birth_death_models Disease_data Latent_incidence_fitting Exponential_figures SIR_model_family talkfigs fitting_code hybrid_fitting SIR_simulations

dropdirs = Lecture_images

rdirs = $(gitdirs) $(dropdirs)

$(gitdirs):
	$(LN) $(gitroot)/$@ .

Lecture_images:
	$(LN) $(Drop)/courses/$@ .

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

