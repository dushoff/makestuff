dushoff_github = https://github.com/dushoff
theobio_github = https://github.com/mac-theobio

$(gitroot)/Disease_data:
	cd $(dir $@) && git clone $(theobio_github)/$(notdir $@).git
