
## Rules for linking to existing cloud folders (not our own mirror structure)
## A lot of complications here; best strategy would be to rewrite mirror.mk:
## make the mirrors just one kind of cloud
## Like if something is in the mirror list, it's also in the cloud list, and automatically inherits the mirror location (based on a settable mirrorHome, currently called cloud or something)
## Maybe better: ?= assign that location to all mirrors manually, allowing override

%.cget: %.cput
	rclone sync -u $(mirror)/$* $*/ 

######################################################################

## Currently working on mirror.mk instead 2024 Sep 21 (Sat)
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
