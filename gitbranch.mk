
## 2023 Jan 29 (Sun)
## Dumping stuff from git.mk

cmain = NULL

## Made a strange loop _once_ (doesn't seem to be used anyway).
# -include $(BRANCH).mk

ifndef BRANCH
BRANCH = $(shell cat .git/HEAD 2>/dev/null | perl -npE "s|.*/||;")
endif

######################################################################

# Branching
%.newbranch:
	git checkout -b $*
	$(MAKE) commit.time
	git push --set-upstream origin $*
	git push -u origin $*

%.branch: commit.time
	git checkout $*

%.checkbranch:
	cd $* && git branch

## Destroy a branch
## Usually call from upmerge (which hasn't been tested for a long time)
%.nuke:
	git branch -D $*
	git push origin --delete $*

upmerge: 
	git rebase $(cmain) 
	git checkout $(cmain)
	git pull
	git merge $(BRANCH)
	git push -u origin $(cmain)
	$(MAKE) $(BRANCH).nuke
