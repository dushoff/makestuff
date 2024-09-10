## If these are working, try to generalize so that we can name our own folders
cloud:
	rclone mkdir $(cloudFolder) --seafile-create-library=true
	mkdir $@

Ignore += cloud.time cloud
cloud.time: $(wildcard cloud/*.*) | cloud
	rclone sync -au cloud $(cloudFolder)
	$(touch)

cloud.get: | cloud
	rclone sync -u $(cloudFolder) cloud

pushup: cloud.time
pullup: cloud.get
