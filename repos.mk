
## It would be cooler to use modular defs like in the old Dropbox version.

ms = makestuff

-include makestuff/repos.def
-include localrepos.def

bitbucket = dushoff@bitbucket.org
github = https://github.com

$(dushoff_bitbucket):
	git clone $(bitbucket):dushoff/$@.git

## Is anything below here tested? What's up with : vs /?

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
