
## cmain is meant to point upstream; don't see any rules
## to manipulate it. Maybe there were once.
## Don't try merging with our rules until this is fixed!
cmain = NULL

## Made a strange loop _once_ (doesn't seem to be used anyway).
# -include $(BRANCH).mk

ifndef BRANCH
BRANCH = $(shell cat .git/HEAD 2>/dev/null | perl -npE "s|.*/||;")
endif

######################################################################

## More makestuff/makestuff weirdness
-include makestuff/exclude.mk
-include exclude.mk

######################################################################

## Hybrid subdirectory types

Ignore += $(clonedirs)
Sources += $(mdirs)

##################################################################

### Push and pull

branch:
	@echo $(BRANCH)
	git branch

Ignore += commit.time commit.default
commit.time: $(Sources)
	$(MAKE) exclude
	-git add -f $? $(trackedTargets)
	(head -1 ~/.commitnow > $@ && echo " ~/.commitnow" >> $@) || echo Autocommit > $@
	echo "## $(CURDIR)" >> $@
	!(git commit --dry-run >> $@) || (perl -pi -e 's/^/#/ unless $$.==1' $@ && $(MSEDIT))
	$(git_check) || (perl -ne 'print unless /#/' $@ | git commit -F -)
	date >> $@

commit.default: $(Sources)
	git add -f $^ 
	-git commit -m "commit.default"
	touch $@
	touch commit.time

pull: commit.time
	git pull
	touch $<

pardirpull: $(pardirs:%=%.pull) makestuff.pull
parpull: pull pardirpull

newSource:
	git add $(Sources)

######################################################################

## parallel directories
## not part of all.time by default because usually updated in parallel
$(pardirs):
	cd .. && $(MAKE) $@
	ls ../$@ > $(null) && $(LNF) ../$@ .

Ignore += up.time all.time
up.time: commit.time
	$(MAKE) pullup
	git push -u origin $(BRANCH)
	touch $@

alldirs += makestuff

######################################################################

## 2020 Jul 19 (Sun) Don't automatically try to sync things that
## haven't been cloned yet
## malldirs are alldirs that have already been made
## pullall might fill in things that aren't here
malldirs = $(filter $(alldirs), $(wildcard *))
all.time: exclude up.time $(malldirs:%=%.all)
	touch $@
	git status .

Ignore += *.all
makestuff.all: %.all: %
	cd $* && $(MAKE) up.time

## Should there be a dependency here? Better chaining?
%.all: 
	$(MAKE) $* $*/Makefile && cd $* && $(MAKE) makestuff && $(MAKE) all.time

do_amsync = (git commit -am "amsync"; git pull; git push; git status .)

autocommit:
	$(MAKE) exclude
	$(git_check) || git commit -am "autocommit from git.mk"
	git status .

amsync:
	$(MAKE) exclude
	$(git_check) || $(do_amsync)

######################################################################

## 2020 Mar 09 (Mon) pull via alldirs 
## 2020 May 23 (Sat) not clear why this would work
## maybe designed to work with pullall recipes?
pullall: $(alldirs:%=%.pullall)

makestuff.pullall: makestuff.pull ;

%.pullall: 
	$(MAKE) $* && cd $* && $(MAKE) makestuff && ($(MAKE) pullall || $(MAKE) pull || $(MAKE) makestuff.pull || (cd makestuff && $(MAKE) pull))

## 2020 May 23 (Sat) ## Different from above? Worse than below?
## Propagates better than pullmake
## Still not clear who pulls (or syncs) what
## What is up doing in pull rules?
## Maybe what is wanted is commit (to check for merge?)
## Or nothing (since pull merges)
pullstuff: $(malldirs:%=%.pullstuff)

makestuff.pullstuff: makestuff.pull ;

%.pullstuff: 
	$(MAKE) $* && cd $* && $(MAKE) makestuff && ($(MAKE) pullstuff || $(MAKE) makestuff.pull || (cd makestuff && $(MAKE) pull))

######################################################################

all.exclude: makestuff.exclude $(malldirs:%=%.allexclude) exclude ;
makestuff.allexclude: ;
%.allexclude:
	cd $* && $(MAKE) all.exclude
%.exclude: 
	cd $* && $(MAKE) exclude

sync: 
	-$(RM) up.time
	$(MAKE) up.time

newpush: commit.time
	git push -u origin master

## Use pullup to add stuff to routine pulls
## without adding to all pulls; maybe not useful?
## or maybe had some submodule something?
pullup: pull

git_check:
	$(git_check)

######################################################################

tsync:
	touch Makefile
	$(MAKE) sync

######################################################################

## autosync stuff not consolidated, needs work. 
remotesync: commit.default
	git pull
	git push -u origin $(BRANCH)

%.autosync: %
	cd $< && $(MAKE) remotesync

######################################################################

%.master: %
	cd $< && git checkout master

%.status: %
	cd $< && git status

%.sync: %
	cd $< && $(MAKE) sync

%.pull: %
	cd $< && ($(MAKE) pull || git pull)

## Not tested (hasn't propagated)
rmpull: $(mdirs:%=%.rmpull) makestuff.pull pull
	git checkout master
	$(MAKE) pull
	git status

%.push: %
	cd $< && $(MAKE) up.time

## git_check is probably useful for some newer rules …
git_check = git diff-index --quiet HEAD --

######################################################################

## git push; make things and add them to the repo

%.gp: % git_push
	cp $* git_push
	git add -f git_push/$*
	touch Makefile

git_push:
	$(mkdir)

## Update everything that's already in the directory
gpobjects = $(wildcard git_push/*)
gptargets = $(gpobjects:git_push/%=%.gp)
gptargets: $(gptargets)

## 2020 Nov 11 (Wed) an alternative name for git_push
## Not copying the all-update rule here; outputs can have other purposes
%.op: % outputs
	- cp $* outputs
	git add -f outputs/$*
	touch Makefile

outputs:
	$(mkdir)

## Do docs/ just like outputs?
%.docs: % docs
	- cp $* docs
	git add -f docs/$*
	touch Makefile

docs:
	$(mkdir)

######################################################################

## Deprecate this for docs/-based directories 2021 Ақп 02 (Сс)
## Redo in a more systematic way (like .branchdir)

## Pages. Sort of like git_push, but for gh_pages (html, private repos)
## May want to refactor as for git_push above (break link from pages/* to * for robustness)

## 2019 Sep 22 (Sun) Keeping checkout, but skipping early pull
## That can make the remote copy look artificially new
## 2019 Oct 10 (Thu)
## But if we don't early pull we get spurious merges
## Best is to pull pages when you pull
%.pages:
	$(MAKE) pages
	cd pages && git checkout gh-pages
	$(MAKE) pages/$*
	cd pages && git add -f $*
	-cd pages && git commit -m "Pushed directly from parent"
	@echo .pagepush to push to web …

%.pushpage: %.pagepush ;
%.pagepush: %.pages
	cd pages && git pull && git push

## Don't call this directly and then we don't need the pages dependency
pages/%: % 
	$(copy)

## If you're going to pushpages automatically, you might want to say
## pull: pages.gitpull

%.gitpull:
	$(MAKE) $*
	cd $* && git pull

%.gitpush:
	$(MAKE) $*
	cd $* && (git add *.* && ($(git_check))) || ((git commit -m "Commited by $(CURDIR)") && git pull && git push && git status)

## Make an empty pages directory when necessary; or else attaching existing one
Ignore += pages
pages:
	git clone `git remote get-url origin` $@
	cd $@ && (git checkout gh-pages || $(createpages)

define createpages
	(git checkout --orphan gh-pages && git rm -rf * && touch ../README.md && cp ../README.md . && git add README.md && git commit -m "Orphan pages branch" && git push --set-upstream origin gh-pages ))
endef

##################################################################

### Rebase problems

continue: $(Sources)
	git add $(Sources)
	git rebase --continue
	git push

abort:
	git rebase --abort

##################################################################

# Special files

~/.config/git:
	$(mkdir)

%/target.mk:
	$(CP) target.mk $*

##################################################################

### Cleaning

remove:
	git rm $(remove)

forget:
	git reset --hard

# Clean all unSourced files (files with extensions only) from directory and repo!!!!
# Dangerous and rarely used
clean_repo:
	git rm --cached --ignore-unmatch $(filter-out $(Sources) $(Archive), $(wildcard *.*))

# Just from directory (also cleans Archive files)
Ignore += .clean_dir
clean_dir:
	-$(RMR) .$@
	mkdir .$@
	$(MV) $(filter-out $(Sources) local.mk $(wildcard *.makestuff), $(wildcard *.*)) .$@

# Fixes untracked files - if you have files included in .gitignore that are present in the repo on github
fix_repo:
	git rm -r --cached .
	git add .
	git commit -m "Fixed untracked files"

$(Outside):
	echo Please get $@ from outside the repo and try again.
	exit 1

######################################################################

## Burn it down!
## 2020 Aug 05 (Wed) This went terribly. Easier to go to github and destroy
## the repo there.

%.warn:
	@echo ctrl-c if you "don't" want to DESTROY $* repo!
	read input
	@echo BOOM

%.destroy:
	@echo ctrl-c if you "don't" want to DESTROY $* repo!
	read input
	- $(RMR) $*.new
	$(MKDIR) $*.new
	cd $*.new && git init
	$(CPF) $*/.git/config $*.new/.git/
	cd $*.new && touch .fake && git add .fake && git commit -m "nuking repo"
	cd $*.new && git push --force --set-upstream origin master
	$(MAKE) $*.reset

%.reset:
	- $(RMR) $*.olddir
	mv $* $*.olddir

%.what:
	rm -fr $*.new

######################################################################

## For security breaches
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

Ignore += dotdir/ clonedir/ cpdir/
dotdir: $(Sources)
	$(MAKE) amsync
	-/bin/rm -rf $@
	git clone . $@

## Note cpdir really means directory (usually); dotdir means the whole repo
## DON'T use cpdir for repos with Sources in subdirectories
## Do use for light applications focused on a particular directory
## DON'T use for service (i.e., makeR scripts)
## Do we have a solution for makeR scripts in subdirectories?
cpdir: $(filter-out %.script, $(Sources))
	-/bin/rm -rf $@
	$(mkdir)
	cp -r $^ $@

## Still working on rev-parse line
%.branchdir: $(Sources)
	$(MAKE) commit.time
	git rev-parse --verify $* || git fetch origin $*:$*
	git clone . $*
	cd $* && git checkout $*
	cd $* && git remote set-url origin `(cd .. && git remote get-url origin)`

clonedir: $(Sources)
	$(MAKE) up.time
	-/bin/rm -rf $@
	git clone `git remote get-url origin` $@
	-cp target.mk $@

repodir: $(Sources)
	-/bin/rm -rf $@
	mkdir $@
	tar czf $@.tgz `git ls-tree -r --name-only master`
	cp $@.tgz $@
	cd $@ && tar xzf $@.tgz && $(RM) $@.tgz
	-cp target.mk $@

sourcedir: $(Sources)
	-/bin/rm -rf $@
	mkdir $@
	tar czf $@.tgz $^
	cp $@.tgz $@
	cd $@ && tar xzf $@.tgz && $(RM) $@.tgz
	-cp target.mk $@

%.localdir: %
	-$(CP) local.mk $*

%.mslink: %
	cd $* && (ls makestuff/Makefile || $(LN) ../makestuff)

testsetup:

%.dirtest: % 
	$(MAKE) $*.testsetup
	$(MAKE) $*.testtarget
	cd $* && $(MAKE) target

## testsetup is before makestuff so we can use it to link makestuff sometimes
%.testsetup: %
	cd $* && $(MAKE) Makefile && $(MAKE) testsetup && $(MAKE) makestuff 

%.makestuff: %
	cd $* && $(MAKE) Makefile && $(MAKE) makestuff

%.testtarget: %
	$(CP) testtarget.mk $*/target.mk || $(CP) target.mk $*

## To open the dirtest final target when appropriate (and properly set up) 
%.vdtest: %.dirtest
	$(MAKE) vtarget

%.localtest: % %.localdir %.dirtest ;

testclean:
	-/bin/rm -rf clonedir dotdir

##################################################################

# Branching
%.newbranch:
	git checkout -b $*
	$(MAKE) commit.time
	git push --set-upstream origin $(BRANCH)
	git push -u origin $(BRANCH)

%.branch: commit.time
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

######################################################################

## Open the web page associated with the repo
## Not clear why sometimes one of these works, and sometimes the other
hub:
	echo go `git remote get-url origin` | bash 

gitremote = git remote get-url origin
gitremoteopen = echo go `$(gitremote) | perl -pe "s/[.]git$$//"` | bash --login

hupstream:
	$(gitremoteopen)

hup:
	$(gitremote)

%.gr:
	cd $* && $(gitremote)

%.gro:
	cd $* && $(gitremoteopen)

%.hup:
	cd $* && echo 0. $*: && $(MAKE) hup

######################################################################

## Moved a bunch of confusing stuff to hybrid.mk
## Cleaned out a bunch of stuff (much later) 2020 Mar 09 (Mon)

######################################################################

## Switch makestuff style in repo made by gitroot 
## Killed 2020 Mar 09 (Mon)

######################################################################

## Violence

## Remove a submodule
%.rmsub:
	-git rm -f $*
	rm -rf .git/modules/$*
	git config --remove-section submodule.$*

## Force push a commit
%.forcepush:
	git push -f origin  $*:master

######################################################################

## Old files

Ignore += *.oldfile *.olddiff
%.oldfile:
	-$(RM) $(basename $*).*.oldfile
	-$(MVF) $(basename $*) tmp_$(basename $*)
	-git checkout $(subst .,,$(suffix $*)) -- $(basename $*)
	-cp $(basename $*) $@
	-$(MV) tmp_$(basename $*) $(basename $*)
	ls $@

## Chaining trick to always remake
## Not clear it works
%.olddiff: %.old.diff ;
%.old.diff: %
	-$(DIFF) $*.*.oldfile $* > $*.olddiff

######################################################################

## Blame

Ignore += *.blame
%.blame: %
	git blame $* > $@

######################################################################

## Git config (just to remind myself)

store_all:
	git config --global credential.helper 'store'
