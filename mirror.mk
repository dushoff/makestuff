
## Rules for sharing files under a standard directory structure with rcloud
## The user must create an rclone “library” at a location pointed to by $(cloud)
## cloudmirror by default

## Where are some .local or .lmk rules??
Ignore += local.mk
-include local.mk

cloud ?= cloudmirror
mirror = $(cloud):$(CURDIR:/home/$(USER)/%=%)

Ignore += *.mirror

.PRECIOUS: %.mirror
%.mirror: 
	rclone copy $*/ $(mirror)/$*
	$(touch)

%.mirror.ls: | %.mirror
	rclone ls $(mirror)/$*

%.backup:
	rclone copy $*/ $(mirror)/backup/$*

%.time: % $(wildcard %/*) | %.mirror
	rclone copy -u $*/ $(mirror)/$*

## This can squash things (intended), but can also go backwards if you have changed anything local since syncing
%.get: %.time
	rclone sync -u $(mirror)/$* $*/ 

## Push deletions upstream (if you're sure you sunk before deleting)
%.syncup:
	rclone sync -u $*/ $(mirror)/$*

