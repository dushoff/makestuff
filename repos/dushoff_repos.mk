
## See makestuff/repos.def ## makestuff/repos.mk

######################################################################

## dushoff_github

## Only for testing setup; this should be completely destroy-able
dushoff_github += creation

## Less-temporary Sandbox stuff
Sandbox: clonecommand=subclone
dushoff_github += Sandbox

## A repo-repo (still good? simplify?) for educational talks
dushoff_github += Workshops

## Rarity stuff with Roswell
dushoff_github += diversity_metrics

## Main Planning repo
dushoff_github += Planning

## Clarity, etc.
dushoff_github += significance

dushoff_github += Circumcision_and_behaviour

######################################################################

dushoff_other = CIHR_Ebola Ebola_stochasticity make Planning rabies-SD RR autorefs dushoff.github.io makework techtex-ebola sherif TZ_clinics rabies_burden nserc_tools SEER_HPV initial_epi diversity_metrics Latent_incidence_fitting DHS_overview Country_lists little_r SIR_model_family Rabies_talks Syphilis_and_ARVs HIV_presentations SIR_simulations scratch permutation_binomial notebook disease_model_talks statistics_talks Ebola_talks Generation_distributions Ebola_sims fitting_code Endemic_curves math_talks texdeps org Workshops gi_appoximations link_calculations

repodirs += $(dushoff_github)

$(dushoff_github):
	$(MAKE) target=$@ repo=$(github) user=dushoff clone

######################################################################

dushoff_bitbucket += New_CV 

bitbucket_other  += talks nserc tutorial Vaccination_analysis TZ_pediatric_HIV zebra_movement Academic_CV Correspondence HIV_Project taxes Sandbox djd QMEE_private tick_math FIDO 1m_2017

$(dushoff_bitbucket):
	$(MAKE) target=$@ repo=$(bitbucket) user=dushoff clone

