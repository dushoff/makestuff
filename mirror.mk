## Rules for sharing files under a standard directory structure with rcloud
## User must create an rclone “library” at a location pointed to by $(cloud)
## cloudmirror: by default

## Deleting some local stuff, why was it here?? 2025 Mar 24 (Mon)
## Where are some .local or .lmk rules??

## This is the default parent location established by an rclone create command
## Modularize later 2025 Apr 11 (Fri)
cloud ?= cloudmirror
mirror = $(cloud):$(CURDIR:/home/$(USER)/%=%)
gmirror = gdrive:$(CURDIR:/home/$(USER)/%=%)

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

## Copy a mirror folder to a google drive for someone to see
%.gsync: %.get
	rclone sync --skip-links -u $*/ $(gmirror)/$*

## This is more like regular posting, but requires mirror logic
%.gp: %
	rclone copy -u $* $(gmirror)/$(notdir $*)

%.glink: %
	rclone link $(gmirror)/$(notdir $*)

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
pushup: mirrorPut
pullup: mirrorGet
report.autoup: mirrorPut

## syncup never finishes (make-wise), but it does put $(mirrorPut) up to date
mirrorUp = $(mirrors:%=%.syncup)
syncup: mirrorUp
