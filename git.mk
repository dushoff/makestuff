
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

## Ignoring

## Find the git directory and make an exclude file here
## When we have subdirectories they may compete (overwrite each others' exclude files)
## Not clear why that would be a problem

git_dir = $(shell git rev-parse --git-dir)

exclude: $(git_dir)/info/exclude ;

$(git_dir)/info/exclude: $(Sources) Makefile
	perl -wf $(ms)/ignore.pl > $@

export Ignore += local.mk target.mk make.log go.log

## Personal ignore stuff see ignore.config

######################################################################

## Hybrid subdirectory types

Ignore += $(clonedirs)
Sources += $(mdirs)

##################################################################

### Push and pull

branch:
	@echo $(BRANCH)
	git branch

sourceadd: 
	git add -f $(Sources)

Ignore += commit.time commit.default
commit.time: $(Sources)
	$(MAKE) exclude
	-git add -f $^
	echo "Autocommit ($(notdir $(CURDIR)))" > $@
	!(git commit --dry-run >> $@) || (perl -pi -e 's/^/#/ unless /Autocommit/' $@ && $(GVEDIT))
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

######################################################################

## parallel directories
## not part of all.time by default because usually updated in parallel
$(pardirs):
	cd .. && $(MAKE) $@
	ls ../$@ > $(null) && $(LNF) ../$@ .

Ignore += up.time all.time
up.time: commit.time
	-git pull
	git push -u origin $(BRANCH)
	touch $@

## trying to switch to alldirs
ifndef alldirs
alldirs = $(mdirs) $(clonedirs) $(subdirs) makestuff
endif

$(subdirs):
	$(mkdir)
	$(CP) $(ms)/subdir.mk $@/Makefile

## 2018 Nov 07 (Wed). Trying to make these rules finish better
all.time: $(alldirs:%=%.all) exclude up.time
	touch $@
	git status

allin: $(alldirs) $(alldirs:%=%.mmsync)

Ignore += *.all
makestuff.all: %.all: %
	cd $* && $(MAKE) up.time

## Should there be a dependency here? Better chaining?
%.all: 
	$(MAKE) $* && cd $* && $(MAKE) all.time

## Bridge rules maybe? Eventually this should be part of all.time
## and all.time does not need to be part of rup
all.exclude: makestuff.exclude $(alldirs:%=%.allexclude) exclude ;
makestuff.allexclude: ;
%.allexclude:
	cd $* && $(MAKE) all.exclude
%.exclude: 
	cd $* && $(MAKE) exclude

sync: 
	$(RM) up.time
	$(MAKE) up.time

allsync: 
	$(RM) all.time
	$(MAKE) all.time

######################################################################

## This probably belongs somewhere else!
addsync: $(add_cache)
	touch Makefile
	$(MAKE) sync

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

%.msync: 
	$(MAKE) $*.master $*.sync

makestuff.mmsync: ;
%.mmsync: 
	cd $* && git checkout master && $(MAKE) makestuff.master makestuff.sync

%.sync: %
	cd $< && $(MAKE) sync

%.pull: %
	cd $< && $(MAKE) pull

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

gpobjects = $(wildcard git_push/*)
gptargets = $(gpobjects:git_push/%=%.gp)
gptargets: $(gptargets)

######################################################################

## Redo in a more systematic way (like .branchdir)

## Pages. Sort of like git_push, but for gh_pages (html, private repos)
## May want to refactor as for git_push above (break link from pages/* to * for robustness)

%.pages:
	$(MAKE) pages/$*
	cd pages && git add -f $* && git commit -m "Pushed from parent" && git pull && git push

pages/%: % pages
	cd pages && git checkout gh-pages
	$(copy)

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

ignore.config: ~/.config/git
	cat $(ms)/ignore.vim $(ms)/ignore.auth $</ignore

README.md LICENSE.md:
	touch $@

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

Ignore += dotdir/ clonedir/
dotdir: $(Sources)
	$(MAKE) commit.time
	-/bin/rm -rf $@
	git clone . $@
	-cp target.mk $@

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

sourcedir: $(Sources)
	-/bin/rm -rf $@
	mkdir $@
	tar czf $@.tgz $^
	cp $@.tgz $@
	cd $@ && tar xzf $@.tgz && $(RM) $@.tgz
	-cp target.mk $@

%.localdir: %
	-$(CP) local.mk $*

%.dirtest: %
	cd $< && $(MAKE) Makefile && $(MAKE) makestuff && $(MAKE) rum && $(MAKE) && $(MAKE) vtarget

%.localtest: % %.localdir %.dirtest ;

testclean:
	-/bin/rm -rf clonedir dotdir

##################################################################

# Branching
%.newbranch:
	git checkout -b $*
	$(MAKE) commit.time
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

update: sync
	git rebase $(cmain) 
	git push origin --delete $*
	git push -u origin $*

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
hupstream:
	echo go `git remote get-url origin | perl -pe "s/[.]git$$//"` | bash --login
hup:
	git remote get-url origin

## Outdated version for github ssh 
upstream:
	git remote get-url origin | perl -pe "s|:|/|; s|[^@]*@|go https://|; s/\.git.*//" | bash --login

######################################################################

## Recursive updating using git submodule functions

## Improved from https://stackoverflow.com/questions/10168449/git-update-submodule-recursive
## Ideal approach would be to have all submodules made with -b from now on.

## Get branch tracking and see how much it helps
## Check https://stackoverflow.com/questions/1777854/git-submodules-specify-a-branch-tag/18799234#18799234 maybe?

rum: rupdate rmaster
ruc: rupdate rcheck
rumfetch: rupdate rfetch rmaster

rupdate:
	git submodule update --init --recursive

rup: rupdate
	git submodule foreach --recursive touch commit.time up.time all.time

rupex: rup
	git submodule foreach --recursive make exclude

pullup: pull rup

## What does this do? Endless loops of commits?
rmaster: 
	git submodule foreach --recursive git checkout master

rcheck: 
	(git submodule foreach --recursive git branch | grep -B1 detached) ||:

## Not sure what's good about this, nor why it apparently needs to be combined with rmaster
## Should we be doing rum; rpull instead? Or nothing?
rfetch:
	git submodule foreach --recursive git fetch

######################################################################

## Keep makestuff up to date without pointless manual commits
## ls -d makestuff is a cheap test for "is this makestuff"?
## Should figure out the right way to test .==makestuff

git_check:
	$(git_check)

## Push new makestuff (probably from this section) to all submodules
## Locally if makestuffs aren't submodules)
shortstuff:
	git submodule foreach '(ls -d makestuff && cd makestuff && git checkout master && git pull) ||:'
## Recursively
newstuff: makestuff.sync
	git submodule foreach --recursive 'ls -d makestuff || (git checkout master && git pull)'

## The principled way to do this seems to be with update merge
## It seems to require config variables?
allmaster: 
	git submodule foreach --recursive 'git checkout master'

upsub:
	git submodule update --init --merge

## This goes through directories that have makestuff and adds and commits just the makestuff
comstuff:
	git submodule foreach --recursive '(ls -d makestuff && make syncstuff) ||: '

## Used to have pull/push manually; should it work instead with rmsync?
## No idea!
syncstuff: makestuff
	git add $< 
	git commit -m $@

rmsync: $(mdirs:%=%.rmsync) makestuff.msync commit.time
	git checkout master
	$(MAKE) sync
	git status

%.rmsync:
	cd $* && $(MAKE) rmsync

pushstuff: newstuff comstuff rmsync

######################################################################

## Is srstuff covered by clone stuff below it?

## Push makestuff changes to subrepos
srstuff:  $(mdirs:%=%.srstuff) $(clonedirs:%=%.srstuff)

%.srstuff:
	cd $*/makestuff && git checkout master && $(MAKE) pull

## Initializing and pulling clones

%.makeclone: % 
	cd $* && $(MAKE) makestuff && $(MAKE) makestuff.master && $(MAKE) makestuff.sync && $(MAKE) makeclones

makeclones: $(clonedirs:%=%.makeclone) ;

## Transitional, doesn't recurse (yet?)

## Just pull
cpstuff: makestuff.pull $(clonedirs:%=%.cpstuff) ;

%.cpstuff: 
	cd $* && $(MAKE) makestuff.pull

csstuff: makestuff.push $(clonedirs:%=%.csstuff) ;

%.csstuff: 
	cd $* && $(MAKE) makestuff.msync && $(MAKE) csstuff

######################################################################

## Moved a bunch of confusing stuff to hybrid.mk

######################################################################

## Switch makestuff style in repo made by gitroot 

makestuff.clone:
	cd $(ms) && $(MAKE) up.time
	$(MAKE) makestuff.rmsub
	git clone $(msrepo)/$(ms)
	perl -pi -e 's/Sources(.*ms)/Ignore$$1/' Makefile

makestuff.sub:
	cd $(ms) && $(MAKE) up.time
	$(RMR) $(ms)
	git submodule add -f -b master $(msrepo)/$(ms)
	perl -pi -e 's/Ignore(.*ms)/Sources $$1/' Makefile

######################################################################

## Violence

## Remove a submodule
%.rmsub:
	-git rm -f $*
	rm -rf .git/modules/$*
	git config --remove-section submodule.$*

## Force push a commit
%.force:
	git push -f origin  $*:master

######################################################################

## Old files

Ignore += *.oldfile *.olddiff
%.oldfile:
	-$(RM) $(basename $*).*.oldfile
	$(MVF) $(basename $*) tmp_$(basename $*)
	-git checkout $(subst .,,$(suffix $*)) -- $(basename $*)
	-cp $(basename $*) $@
	$(MV) tmp_$(basename $*) $(basename $*)
	ls $@

## Chaining trick to always remake
## Not clear it works
%.olddiff: %.old.diff ;
%.old.diff: %
	-$(DIFF) $* $*.*.oldfile > $*.olddiff

######################################################################

## Blame

Ignore += *.blame
%.blame: %
	git blame $* > $@

######################################################################

## Git config (just to remind myself)

store_all:
	git config --global credential.helper 'store'
