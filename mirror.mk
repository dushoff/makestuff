## Rules for sharing files under a standard directory structure with rcloud
## User must create an rclone “library” at a location pointed to by $(cloud)
## cloudmirror: by default

## Where are some .local or .lmk rules??
Ignore += local.mk
-include local.mk

## This is the default parent location established by an rclone create command
cloud ?= cloudmirror
mirror = $(cloud):$(CURDIR:/home/$(USER)/%=%)

Ignore += *.mirror
Ignore += $(mirrors)

## Maybe not needed, pay attention
.PRECIOUS: %.mirror
%.mirror: 
	rclone mkdir $(mirror)/$*
	rclone copy -u $*/ $(mirror)/$*
	$(touch)

%.mirror.ls: | %.mirror
	rclone ls $(mirror)/$*

%.backup:
	rclone copy -u $*/ $(mirror)/backup/$*

######################################################################

## Dangerous rules
%.syncup:
	rclone sync --skip-links -u $*/ $(mirror)/$*
	touch $*.puttime
%.syncdown:
	rclone sync -u $(mirror)/$* $*/ 

## Normally copy up safely; syncup can be called manually
## Can try to fix with an || !ls something [[fix WHAT? 2025 Feb 12 (Wed)]]
%.put: | % %.mirror
	rclone copy --skip-links -u $* $(mirror)/$* --exclude ".*"

Ignore += *.puttime
%.puttime: % $(wildcard %/*)
	$(MAKE) $*.put
	$(touch)

## Allow file deletions to propagate
## But only if nothing here has changed since last sync
%.get: %.puttime
	rclone sync -u $(mirror)/$* $*/ 

mirrorGet: $(mirrors:%=%.get)
mirrorPut: $(mirrors:%=%.puttime)

$(mirrors): ; $(mkdir)
pushup: mirrorGet
pullup: mirrorPut

## syncup never finishes (make-wise), but it does put $(mirrorPut) up to date
mirrorUp = $(mirrors:%=%.syncup)
syncup: mirrorUp

## Check on this; repetitive with pushup?
up.time: mirrorPut

