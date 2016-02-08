dushoff_github = https://github.com/dushoff
theobio_github = https://github.com/mac-theobio
outbreak_github = https://github.com/Outbreak-analysis


$(gitroot)/Disease_data:
	cd $(dir $@) && git clone $(theobio_github)/$(notdir $@).git

$(gitroot)/makestuff $(gitroot)/SIR_model_family:
	cd $(dir $@) && git clone $(dushoff_github)/$(notdir $@).git

$(gitroot)/WA_Ebola_Outbreak:
	cd $(dir $@) && git clone $(outbreak_github)/$(notdir $@).git
