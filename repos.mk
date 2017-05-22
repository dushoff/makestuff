
-include $(ms)/repos.def

$(dushoff_github):
	git clone $(github)/dushoff/$@.git

$(outbreak_github):
	git clone $(github)/Outbreak-analysis/$@.git

$(Bio3SS):
	git clone $(github)/Bio3SS/$@.git

$(theobio_group):
	git clone $(github)/mac-theobio/$@.git
