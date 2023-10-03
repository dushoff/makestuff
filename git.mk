## More makestuff/makestuff weirdness
-include makestuff/exclude.mk
-include exclude.mk

######################################################################

### Push and pull

branch:
	@echo $(BRANCH)
	git branch

sourceTouch = touch $(word 1, $(Sources))

Ignore += commit.time commit.default
commit.time: $(Sources)
	$(MAKE) exclude
	-git add -f $? $(trackedTargets)
	(head -1 ~/.commitnow > $@ && echo " ~/.commitnow" >> $@) || echo Autocommit > $@
	echo "## $(CURDIR)" >> $@
	!(git commit --dry-run >> $@) || (perl -pi -e 's/^/#/ unless $$.==1' $@ && $(MSEDIT))
	$(git_check) || (perl -ne 'print unless /^#/' $@ | git commit -F -)
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
	cd ../$@ &&  $(MAKE) Makefile
	ls ../$@ > $(null) && $(LNF) ../$@ .

Ignore += up.time all.time
up.time: commit.time
	$(MAKE) pullup
	$(MAKE) pushup
	touch $@

alldirs += makestuff

pardirpull: $(pardirs:%=%.pull) makestuff.pull
parpull: pull pardirpull

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

autocommit:
	$(MAKE) exclude
	$(git_check) || git commit -am "autocommit from git.mk"
	git status .

## No idea what add -u is supposed to do. What if I added a dot?
## Also it doesn't work, where commit -am seems to.
addall:
	git add -u
	git add -f $(Sources)

tsync:
	$(sourceTouch)
	$(MAKE) up.time

forcesync: addall tsync

%.forcesync:
	cd $* && $(MAKE) forcesync

######################################################################

pullall: $(alldirs:%=%.pullall)
	$(MAKE) pull

makestuff.pullall: makestuff.pull ;

%.pullall: 
	$(MAKE) $* && $(MAKE) $*/Makefile 
	cd $* && $(MAKE) makestuff && $(MAKE) makestuff && $(MAKE) makestuff.pull
	cd $* && ($(MAKE) pullall || $(MAKE) pull || git pull)

## 2020 May 23 (Sat) ## Different from above? Worse than below?
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

## Use for first push if not linked to a branch
push.%: commit.time
	git push -u origin $*

## Use pullup to add stuff to routine pulls
## without adding to all pulls; maybe not useful?
## 2022 Aug 05 (Fri) added submodule incantation
## 2023 Jan 29 (Sun) subtracted submodule incantation; add it manually to submodule directories

pullup: pull

modupdate = git submodule update -i

## 2022 Sep 01 (Thu)
## This doesn't work for new, blank repos and I don't know why
## I also don't know if the whole origin branch stuff is helping anyone
pushup:
	git push -u origin $(BRANCH)

git_check:
	$(git_check)

######################################################################

Ignore += *.setbranch
%.setbranch:
	$(RM) *.setbranch
	git checkout $* 
	$(touch)

######################################################################

## autosync stuff not consolidated, needs work. 
remotesync: commit.default
	git pull
	git push -u origin $(BRANCH)

%.autosync: %
	cd $< && $(MAKE) remotesync

######################################################################

%.status: %
	cd $< && git status

%.sync: %
	cd $< && $(MAKE) sync

%.pull: %
	cd $< && ($(MAKE) pull || git pull)

%.push: %
	cd $< && $(MAKE) up.time

git_check = git diff-index --quiet HEAD --

######################################################################

## git push; make things and add them to the repo

%.gp: % git_push
	cp $* git_push
	git add -f git_push/$*
	$(sourceTouch)

git_push:
	$(mkdir)

## Update everything that's already in the directory
gpobjects = $(wildcard git_push/*)
gptargets = $(gpobjects:git_push/%=%.gp)
gptargets: $(gptargets)

######################################################################

## Unify some of these by recipe
## use a better touch command

## 2020 Nov 11 (Wed) an alternative name for git_push
## Not copying the all-update rule here; outputs can have other purposes
%.op: % outputs
	- $(CPF) $* outputs
	git add -f outputs/$*
	$(sourceTouch)

%.opdir: % outputs
	- $(RMR) outputs/$*
	- $(CPR) $* outputs
	git add -f outputs/$*
	$(sourceTouch)

## auto-docs causes conflict in dataviz
outputs:
	$(mkdir)

%.docs: % docs
	- cp $* docs
	git add -f docs/$*
	$(sourceTouch)

## Commented out because of stupid dataviz conflict 2021 Nov 02 (Tue)
## docs: ; $(mkdir)

######################################################################

## Make an empty pages directory when necessary; or else attaching existing one
Ignore += pages
pages:
	git clone --branch gh-pages `git remote get-url origin` $@

pages/pagebranch:
	cd $(dir $@) && (git checkout gh-pages || $(createpages))
	touch $@

%.pages: % pages
	- $(CPF) $* pages
	git add -f pages/$*
	$(sourceTouch)

gitarchive/%: gitarchive
gitarchive:
	$(mkdir)
trackedTargets += $(wildcard gitarchive/*)

######################################################################

## Deprecate this for docs/-based directories 2021 Ақп 02 (Сс)
## Redo in a more systematic way (like .branchdir)

## Pages. Sort of like git_push, but for gh_pages (html, private repos)
## May want to refactor as for git_push above (break link from pages/* to * for robustness)

## 2021 Мам 27 (Бс) Probably deprecated, but could update to follow docs style
## 2019 Sep 22 (Sun) Keeping checkout, but skipping early pull
## That can make the remote copy look artificially new
## 2019 Oct 10 (Thu)
## But if we don't early pull we get spurious merges
## Best is to pull pages when you pull
Ignore += pagebranch
%.pages:
	$(MAKE) pages/pagebranch
	$(MAKE) pages/$*
	cd pages && git add -f $*
	-cd pages && git commit -m "Pushed directly from parent"
	@echo .pagepush to push to web …

%.pushpage: %.pagepush ;
%.pagepush: %.pages
	cd pages && git pull && git push

pages/Makefile:
	cp Makefile $@

## Don't call this directly and then we don't need the pages dependency
## In development (or deprecation) 2021 Мам 27 (Бс)
## pages/%: %; $(copy)

## If you're going to pushpages automatically, you might want to say
## pull: pages.gitpull

%.gitpull:
	$(MAKE) $*
	cd $* && git pull

## Deprecated: use output, pages, docs ….
%.gitpush:
	$(MAKE) $*
	cd $* && (git add *.* && ($(git_check))) || ((git commit -m "Commited by $(CURDIR)") && git pull && git push && git status)


define createpages
	(git checkout --orphan gh-pages && git rm -rf * && touch ../README.md && cp ../README.md . && git add README.md && git commit -m "Orphan pages branch" && git push --set-upstream origin gh-pages )
endef

%.branchdir:
	git clone `git remote get-url origin` $*

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
	$(MAKE) commit.time
	-/bin/rm -rf $@
	git clone . $@
	[ "$(pardirs)" = "" ] || ( cd $@ && $(LN) $(pardirs:%=../%) .)

## Note cpdir really means directory (usually); dotdir means the whole repo
## DON'T use cpdir for repos with Sources in subdirectories
## Do use for light applications focused on a particular directory
## DON'T use for service (i.e., makeR scripts)
## Do we have a solution for makeR scripts in subdirectories?
## Note that I am using it now for pipeR scripts, so that's probably fragile 2021 Jun 27 (Sun)
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

sourcedir: $(Sources)
	-/bin/rm -rf $@
	mkdir $@
	tar czf $@.tgz $^
	cp $@.tgz $@
	cd $@ && tar xzf $@.tgz && $(RM) $@.tgz
	-cp target.mk $@

%.localdir: % %.mslink
	-$(CP) local.mk $*

%.mslink: %
	cd $* && (ls makestuff/Makefile || $(LN) ../makestuff)

%.dirtest: % 
	$(MAKE) $*.testsetup
	$(MAKE) $*.testtarget
	cd $* && $(MAKE) target

## testsetup is before makestuff so we can use it to link makestuff sometimes
%.testsetup: %
	cd $* && $(MAKE) Makefile && ($(MAKE) testsetup || true) && $(MAKE) makestuff 

%.makestuff: %
	cd $* && $(MAKE) Makefile && $(MAKE) makestuff

%.testtarget: %
	$(CP) testtarget.mk $*/target.mk || $(CP) target.mk $*

## To open the dirtest final target when appropriate (and properly set up) 
%.vdtest: %.dirtest
	$(MAKE) pdftarget


## To make and display files in the all variable
alltest:
	$(MAKE) $(all) && ($(MAKE) $(all:%=%.go) || echo "Warning: alltest made but could not display everything" )
%.alltest: %.dirtest
	$(MAKE) alltest

## Get it? 
%.localtest: % %.localdir %.vdtest ;
%.localltest: % %.localdir %.alltest ;

## This is def. incomplete, but I never use it 2022 Sep 24 (Sat)
testclean:
	-/bin/rm -rf clonedir dotdir

######################################################################

## Open the web page associated with the repo
## Not clear why sometimes one of these works, and sometimes the other
hub:
	echo go `git remote get-url origin` | bash 

gitremote = git remote get-url origin
gitremoteopen = echo go `$(gitremote) | perl -pe "s/[.]git$$//"` | bash --login
gitremotestraight = echo go `$(gitremote) | perl -pe "s/[.]git$$//"` | bash

hupstream:
	$(gitremotestraight)

hup:
	$(gitremote)

%.gr:
	cd $* && $(gitremote)

%.gro:
	cd $* && $(gitremoteopen)

%.hup:
	cd $* && echo 0. $*: && $(MAKE) hup

######################################################################

## Violence

## Remove a submodule
%.rmsub:
	-git rm -f $*
	rm -rf .git/modules/$*
	git config --remove-section submodule.$*

######################################################################

## Merging

Ignore += *.ours *.theirs *.common

## Look at merge versions
%.common: %
	git show :1:$* > $@

%.ours: %
	git show :2:$* > $@

%.theirs: %
	git show :3:$* > $@

## Pick one
%.pick: %
	$(CP) $* $(basename $*)
	git add $(basename $*)

Ignore += *.gitdiff
%.gitdiff: %.ours %.theirs
	- $(diff)

######################################################################

## Old files. <fn.ext>.<tag>.oldfile; use .arcfile to skip automatic deletion of other old files

Ignore += *.oldfile *.olddiff *.arcfile
%.oldfile:
	-$(RM) $(basename $*).*.oldfile
	$(oldfile_r)

%.arcfile: 
	$(oldfile_r)

define oldfile_r
	- $(call hide, $(basename $*))
	-git checkout $(subst .,,$(suffix $*)) -- $(basename $*)
	-cp $(basename $*) $@
	-git checkout HEAD -- $(basename $*)
	- $(call unhide, $(basename $*))
	ls $@
endef

## Chaining trick to always remake
## Is this better or worse than writing dependencies and making directly?
%.olddiff: %.old.diff ;
%.old.diff: %
	- $(RM) $*.olddiff
	-$(DIFF) $*.*.oldfile $* > $*.olddiff
	$(RO) $*.olddiff

Ignore += *.newfile *.newdiff
%.newdiff: %.new.diff ;
%.new.diff: %
	- $(RM) $*.newdiff
	-$(DIFF) $*.*.newfile $* > $*.newdiff
	$(RO) $*.newdiff

######################################################################

## Blame

Ignore += *.blame
%.blame: %
	git blame $* > $@

######################################################################

## Git config (just to remind myself)

store_all:
	git config --global credential.helper 'store'
