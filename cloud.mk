## If these are working, try to generalize so that we can name our own folders
cloud:
	rclone mkdir $(cloudFolder) --seafile-create-library=true
	mkdir $@

Ignore += cloud.time
commit.time: cloud.time
cloud.time: $(wildcard cloud/*.*) | cloud
	rclone sync -u cloud $(cloudFolder)
	$(touch)

cloud.get: | cloud
	rclone sync -u $(cloudFolder) cloud
