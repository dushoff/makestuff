### Git for _centralized_ workflow
### Trying to generalize now

cmain = NULL

## Made a strange loop _once_ (doesn't seem to be used anyway).
# -include $(BRANCH).mk

ifndef BRANCH
BRANCH=master
endif

##################################################################

### Push and pull

branch:
	@echo $(BRANCH)

newpush: commit.time
	git push -u origin master

## Deprecate this; we should always pull before push, right?
push: commit.time
	git push -u origin $(BRANCH)

pull: commit.time
	git pull
	touch $<

pullup: commit.time
	git pull
	git submodule update --init --recursive
	git submodule foreach --recursive git fetch
	git submodule foreach --recursive git merge origin master
	touch $<

rebase: commit.time
	git fetch
	git rebase origin/$(BRANCH)
	touch $<

addsync: $(add_cache)
	touch Makefile
	$(MAKE) sync

tsync:
	touch Makefile
	$(MAKE) sync

rbsync:
	$(MAKE) rebase
	$(MAKE) push

psync:
	$(MAKE) pull
	git push -u origin $(BRANCH)

sync: psync ;

msync: commit.time
	git checkout master
	$(MAKE) sync

######################################################################

## Recursive syncing with some idea about up vs. down

up.time: commit.time
	$(MAKE) sync
	date > $@

## Do these really need recipes? Concern is phantom making
rmup: $(mdirs:%=%.rmup) makestuff.msync mup

mup: master up.time

%.mup: %
	cd $< && $(MAKE) rmup

%.rmup: %
	cd $< && $(MAKE) rmup

######################################################################

## Recursive sync everything to master. Be careful, I guess.
## mdirs for subdirectories that should be synced to master branch
rmsync: $(mdirs:%=%.rmsync) makestuff.msync commit.time
	git checkout master
	$(MAKE) sync
	git status

rmpull: $(mdirs:%=%.rmpull) makestuff.mpull
	git checkout master
	$(MAKE) pull

rmpush: $(mdirs:%=%.rmpush) makestuff.mpush
	git checkout master
	$(MAKE) push

remotesync: commit.default
	git pull
	git push -u origin $(BRANCH)

%.newpush: %
	cd $< && $(MAKE) newpush

%.msync: %.master %.sync ;
%.sync: %
	cd $< && $(MAKE) sync
%.rmsync: %
	cd $< && ($(MAKE) rmsync || (git checkout master && $(MAKE) sync && $(MAKE) makestuff.master && $(MAKE) makestuff.sync))

%.mpull: %.master %.pull ;
%.pull: %
	cd $< && $(MAKE) pull
%.rmpull: %
	cd $< && ($(MAKE) rmpull || (git checkout master && $(MAKE) sync && $(MAKE) makestuff.master && $(MAKE) makestuff.sync))

%.mpush: %.master %.push ;
%.push: %
	cd $< && $(MAKE) push

%.rmpush: %
	cd $< && ($(MAKE) rmpush || $(MAKE) msync)

%.autosync: %
	cd $< && $(MAKE) remotesync

## Archive is _deprecated_; see .gp:
## If you really want something remade and archived automatically, it can be a source

## Check function (how to use??)

git_check = git diff-index --quiet HEAD --

commit.time: $(Sources)
	-git add -f $^
	echo "Autocommit ($(notdir $(CURDIR)))" > $@
	!(git commit --dry-run >> $@) || (perl -pi -e 's/^/#/ unless /Autocommit/' $@ && $(EDIT) $@)
	$(git_check) || (perl -ne 'print unless /#/' $@ | git commit -F -)
	date >> $@

commit.default: $(Sources)
	git add -f $^ 
	-git commit -m "Pushed automatically"
	touch $@

######################################################################

## git push; make things and add them to the repo
## Testing streamlined version Jul 2017

%.gp: % git_push
	cp $* git_push
	git add -f git_push/$*
	touch Makefile

git_push:
	$(mkdir)

## Pages. Sort of like git_push, but for gh_pages (html, private repos)
## May want to refactor as for git_push above (break link from pages/* to * for robustness)

%.pages:
	$(MAKE) pages/$*
	cd pages && git add -f $* && git commit -m "Pushed from parent" && git pull && git push

pages/%: % pages
	cd pages && git checkout gh-pages
	$(copy)

pages:
	$(makesub)
	cd $@ && (git checkout gh-pages || $(orphanpages)

define orphanpages
	(git checkout --orphan gh-pages && git rm -rf * && touch ../README.md && cp ../README.md . && git add README.md && git commit -m "Orphan pages branch" && git push --set-upstream origin gh-pages ))
endef

##################################################################

### Rebase

continue: $(Sources)
	git add $(Sources)
	git rebase --continue
	git push

abort:
	git rebase --abort

##################################################################

# Special files

.gitignore:
	-/bin/cp $(ms)/$@ .

README.md LICENSE.md:
	touch $@

##################################################################

### Cleaning

remove:
	git rm $(remove)

forget:
	git reset --hard

# Clean all unSourced files (files with extensions only) from directory and repo!!!!
clean_repo:
	git rm --cached --ignore-unmatch $(filter-out $(Sources) $(Archive), $(wildcard *.*))

# Just from directory (also cleans Archive files)
clean_dir:
	-$(RMR) .$@
	mkdir .$@
	$(MV) $(filter-out $(Sources) local.mk $(wildcard *.makestuff), $(wildcard *.*)) .$@

### Not clear whether these rules actually play well together!
clean_both: clean_repo clean_dir

# Fixes untracked files - if you have files included in .gitignore that are present in the repo on github
fix_repo:
	git rm -r --cached .
	git add .
	git commit -m "Fixed untracked files"

$(Outside):
	echo Please get $@ from outside the repo and try again.
	exit 1

##### Annihilation
%.annihilate: sync
	git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch $*' --prune-empty --tag-name-filter cat -- --all

forcepush:
	git push origin --force --all
	git push origin --force --tags

## In theory you might want to check things out before doing this one.
gitprune:
	git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
	git reflog expire --expire=now --all
	git gc --prune=now

##################################################################

### Testing

dotdir: $(Sources)
	$(MAKE) commit.time
	-/bin/rm -rf $@
	git clone . $@
	-cp target.mk $@

clonedir: $(Sources)
	$(MAKE) push
	-/bin/rm -rf $@
	git clone `git remote get-url origin` $@
	-cp target.mk $@

%.localdir: %
	-$(CP) local.mk $*

%.dirtest: %
	cd $< && $(MAKE) Makefile && $(MAKE) makestuff && $(MAKE) && $(MAKE) vtarget

%.localtest: % %.localdir %.dirtest

testclean:
	-/bin/rm -rf clonedir dotdir

##################################################################

# Branching
%.newbranch:
	git checkout -b $*
	$(MAKE) commit.time
	git push -u origin $(BRANCH)

%.branch: sync
	git checkout $*

%.checkbranch:
	cd $* && git branch

%.master:
	cd $* && git checkout master
master: 
	git checkout master

## Try this stronger rule some time!
# %.master: %
#	cd $< && git checkout master

update: sync
	git rebase $(cmain) 
	git push origin --delete $*
	git push -u origin $*

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

upstream:
	git remote get-url origin | perl -pe "s|:|/|; s|[^@]*@|go https://|; s/\.git.*//" | bash --login

hupstream:
	echo go `git remote get-url origin` | bash --login

######################################################################

## Recursive updating with submodules

## Cribbed from https://stackoverflow.com/questions/10168449/git-update-submodule-recursive
## Doesn't seem to do what I want
## Sets lots of things to headless, or something.
## Investigate more
rupdate:
	git submodule update --init --recursive
	git submodule foreach --recursive git fetch
	git submodule foreach --recursive git merge origin master

## Remove a submodule
%.rmsub:
	-git rm $*
	rm -rf .git/modules/$*
	git config -f .git/config --remove-section submodule.$*

######################################################################

## Old files
## Should be modified to:

%.oldfile:
	-$(RM) $(basename $*).*.oldfile
	$(MVF) $(basename $*) tmp_$(basename $*)
	git checkout $(subst .,,$(suffix $*)) -- $(basename $*)
	cp $(basename $*) $@
	$(MV) tmp_$(basename $*) $(basename $*)

%.olddiff: $(wildcard %*)
	-$(DIFF) $* $*.*.oldfile > $@

######################################################################

## Git config (just to remind myself)

store_all:
	git config --global credential.helper 'store'
