
## Rules for sharing files under a standard directory structure with rcloud
## User must create an rclone “library” at a location pointed to by $(cloud)
## cloudmirror: by default

## Where are some .local or .lmk rules??
Ignore += local.mk
-include local.mk

cloud ?= cloudmirror
mirror = $(cloud):$(CURDIR:/home/$(USER)/%=%)

Ignore += *.mirror

.PRECIOUS: %.mirror
%.mirror: 
	rclone mkdir $(mirror)/$*
	rclone copy $*/ $(mirror)/$*
	$(touch)

%.mirror.ls: | %.mirror
	rclone ls $(mirror)/$*

%.backup:
	rclone copy $*/ $(mirror)/backup/$*

######################################################################

## Dangerous rules
%.syncup:
	rclone sync -u $*/ $(mirror)/$*
%.syncdown:
	rclone sync -u $(mirror)/$* $*/ 

## Normally copy up safely; syncup can be called manually
%.put: | %.mirror
	rclone copy -u $*/ $(mirror)/$*

Ignore += *.puttime
%.puttime: % $(wildcard %/*)
	$(MAKE) $*.put
	$(touch)

## Allow file deletions to propagate
## But only if nothing here has changed since last sync
%.get: %.puttime
	rclone sync -u $(mirror)/$* $*/ 

mirrorGet = $(mirrors:%=%.get)
mirrorPut = $(mirrors:%=%.puttime)

pushup: $(mirrorGet)
pullup: $(mirrorPut)
