github = https://github.com
theobio_github = https://github.com/mac-theobio
outbreak_github = https://github.com/Outbreak-analysis

dushoff_github = CIHR_Ebola Ebola_stochasticity make Planning rabies-SD RR autorefs dushoff.github.io makework techtex-ebola sherif makestuff TZ_clinics rabies_burden nserc_tools SEER_HPV initial_epi diversity_metrics Latent_incidence_fitting DHS_overview Country_lists little_r SIR_model_family Rabies_talks Syphilis_and_ARVs HIV_presentations SIR_simulations Circumcision_and_behaviour scratch permutation_binomial notebook disease_model_talks statistics_talks Ebola_talks Generation_distributions Ebola_sims
$(dushoff_github):
	git clone $(github)/dushoff/$@.git

Bio3SS = Bio3SS.github.io Bio3SS_content Population_time_series Lecture_images Exponential_figures Grading_scripts Assignments Birth_death_models Compensation_models Life_tables Life_history Age_distributions Structured_models 3SS Competition_models Exploitation_models
$(Bio3SS):
	git clone $(github)/Bio3SS/$@.git
