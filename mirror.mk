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

######################################################################

## List a subdirectory of the main mirror
%.mirror.ls: | %.mirror
	rclone ls $(mirror)/$*

## Sometimes we use gmirror in parallel (for sharing)
gmirror.ls:
	rclone ls $(gmirror)

%.backup:
	rclone copy -u $*/ $(mirror)/backup/$*

######################################################################

## Dangerous rules
%.syncup:
	rclone sync --skip-links -u $*/ $(mirror)/$*
%.syncdown:
	rclone sync -u $(mirror)/$* $*/ 

%.vaporize:
	rm -fr $*/*
	$(MAKE) $*.syncup

## Copy a mirror folder to a google drive for someone to see
## Use .glink to get the link
%.gsync: %.get
	rclone sync --skip-links -u $*/ $(gmirror)/$*

######################################################################

## This is more like regular posting, but it's here because of $(gmirror)
%.gp: %
	rclone copy -u $* $(gmirror)/$(notdir $*)

## This way is supposed to do less slow uploading
## Two passes: build the source first, so that gdrive/% (rather than some other
## pattern rule, like %.md.pdf: %.md, chaining inside gdrive/) makes the stamp
%.gd:
	$(MAKE) $(or $(filter %/$*,$(gdsub)),$*)
	$(MAKE) gdrive/$(notdir $*)

.PRECIOUS: gdrive/%
## Upload first; the local copy is the stamp, so make it only after the upload succeeds
gdrive/%: % | gdrive
	rclone copyto -u $< $(gmirror)/$(notdir $@)
	$(copy)

gdtargets = $(addprefix gdrive/, $(notdir $(gdsub)))
$(gdtargets): | gdrive
	rclone copyto -u $< $(gmirror)/$(notdir $@)
	$(copy)

define gdsub_dep
gdrive/$(notdir $(1)): $(1) | gdrive
endef
$(foreach f,$(gdsub),$(eval $(call gdsub_dep,$(f))))

gdrive:
	$(mkdir)

## Dangerous: empty this directory's gmirror folder (Drive keeps the folder and its link;
## files go to Drive trash), and clear the local gdrive/ stamps so .gd re-uploads
gdclear:
	rclone delete --rmdirs $(gmirror)
	$(RM) gdrive/*

## Report local gdrive/ stamps whose files are missing or different on Drive
gdcheck: | gdrive
	rclone check --one-way ./gdrive $(gmirror)

######################################################################

%.glink: %
	echo $(open) `rclone link $(gmirror)/$(notdir $*)` | bash

## Make this directory's Drive folder readable by anyone with the link, and open it
gdlink:
	echo $(open) `rclone link $(gmirror)` | bash

######################################################################

## Normally copy up safely; syncup can be called manually
## Can try to fix with an || !ls something [[fix WHAT? 2025 Feb 12 (Wed)]]
%.put: | % %.mirror
	rclone copy --skip-links -u $* $(mirror)/$* --exclude ".*"

## puttime stamps retired 2026 Nov 16 (Mon): the dependency only saw the
## directory's mtime, so in-place edits were missed. Now we always put
## (rclone copy -u skips unchanged files, and it runs in the background)
Ignore += *.puttime

## Allow file deletions to propagate
## But put first, so local changes aren't clobbered
%.get: %.put
	rclone sync -u $(mirror)/$* $*/ 

mirrorGet: $(mirrors:%=%.get)
mirrorPut: $(mirrors:%=%.put)

$(mirrors): ; $(mkdir)
## Background mirroring, so push/pull don't wait for rclone 2026 Nov 16 (Mon)
## Both directions share one lock: a second request waits its turn
## setsid: survive closing the terminal; MAKEFLAGS dropped so the child
## doesn't look for the parent's (gone) jobserver
## Check mirror.log if something seems not to have arrived
Ignore += mirror.log .mirror.lock
bgmirror = setsid sh -c '{ echo "== $$(date) $(1)"; flock .mirror.lock env -u MAKEFLAGS -u MFLAGS $(MAKE) --no-print-directory $(1) || echo "!! $(1) FAILED"; } >> mirror.log 2>&1 < /dev/null' &

mirrorBP:
	$(call bgmirror,mirrorPut)
mirrorBG:
	$(call bgmirror,mirrorGet)

pushup: mirrorBP
pullup: mirrorBG
report.autoup: mirrorBP

## syncup never finishes (make-wise), but it does put $(mirrorPut) up to date
mirrorUp = $(mirrors:%=%.syncup)
syncup: mirrorUp

######################################################################

## This logic needs more work
archivemirror/%: | % oldmirror
	rclone sync -u $(mirror)/$* $*/ 
	$(MV) $* $@
	$(MAKE) $*
	$(MAKE) $*.syncup

oldmirror/%: | % oldmirror
	$(MV) $* $@
	rclone sync -u $(mirror)/$* $*/ 

oldmirror:
	$(mkdir)
