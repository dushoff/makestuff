
## It would be cooler to use modular defs like in the old Dropbox version.

-include $(ms)/repos.def

$(dushoff_github):
	git clone $(github)/dushoff/$@.git

$(outbreak_github):
	git clone $(github)/Outbreak-analysis/$@.git

$(Bio1M):
	git clone $(github)/Bio1M/$@.git

$(Bio3SS):
	git clone $(github)/Bio3SS/$@.git

$(theobio_group):
	git clone $(github)/mac-theobio/$@.git
