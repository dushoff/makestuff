## If these are working, try to generalize so that we can name our own folders
cloud:
	rclone mkdir $(cloudFolder) --seafile-create-library=true
	mkdir $@

Ignore += cloud.time cloud
cloud.time: $(wildcard cloud/*.*) | cloud
	rclone sync -u cloud $(cloudFolder)
	$(touch)

cloud.get: | cloud
	rclone sync -u $(cloudFolder) cloud

######################################################################

## Building slowly

%.get: | %
	rclone sync -u $(cloudFolder) $*

## If we always get before we put, then we should have the newest version
## of any file, and there's no risk to sync without -u
## But we still probably can't get rid of files that are in more than one place
%.put: %.get
	rclone sync $* $(cloudFolder)
