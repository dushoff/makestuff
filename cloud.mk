## If these are working, try to generalize so that we can name our own folders
cloud:
	rclone mkdir $(cloudFolder) --seafile-create-library=true
	mkdir $@

Ignore += cloud.time cloud
cloud.time: cloud $(wildcard cloud/*.*)
	$(MAKE) cloud.put
	$(touch)

## No way to delete anything for now, figure it out later 2024 Sep 15 (Sun)
%.get: | %
	rclone copy -u $(cloudFolder) $*

%.put: %.get
	rclone copy -u $* $(cloudFolder)
