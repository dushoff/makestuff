### Git for _centralized_ workflow
### Trying to generalize now

cmain = NULL

## Made a strange loop _once_ (doesn't seem to be used anyway).
# -include $(BRANCH).mk

ifndef BRANCH
BRANCH=master
endif

######################################################################

## Ignoring Make this a separate file?? ignore.mk

## We don't want automatic gitignore rule to work in makestuff
## the perl dependency should stop it

export Ignore += up.time commit.time commit.default dotdir/ clonedir/
## Put .gitignore into .ignore

.gitignore: .ignore $(filter-out .gitignore, $(Sources)) $(ms)/ignore.pl
	$(hardcopy)
	perl -wf $(ms)/ignore.pl >> $@
	$(RO)

## Hybridizing and cleaning up; some of these rules should be phased out
hybridignore: $(clonedirs:%=%.hybridignore) $(mdirs:%=%.hybridignore);
cloneignore: $(clonedirs:%=%.cloneignore) ;
modignore: $(mdirs:%=%.modignore) ;

%.hybridignore: 
	cd $* && $(MAKE) Makefile.ignore && $(MAKE) hybridignore

%.cloneignore: 
	cd $* && $(MAKE) Makefile.ignore && $(MAKE) cloneignore

%.modignore: 
	cd $* && $(MAKE) Makefile.ignore && $(MAKE) modignore

Makefile.ignore:
	perl -pi -e 's/(Sources.*).gitignore/$$1.ignore/' Makefile
	-git rm .gitignore

Ignore += $(clonedirs)
Sources += $(mdirs)

##################################################################

### Push and pull

branch:
	@echo $(BRANCH)

commit.time: $(Sources)
	$(MAKE) .gitignore
	-git add -f $^
	echo "Autocommit ($(notdir $(CURDIR)))" > $@
	!(git commit --dry-run >> $@) || (perl -pi -e 's/^/#/ unless /Autocommit/' $@ && $(EDIT) $@)
	$(git_check) || (perl -ne 'print unless /#/' $@ | git commit -F -)
	date >> $@

## This logic could probably be integrated better with commit.time
## Trying something … last line of recipe
commit.default: $(Sources)
	git add -f $^ 
	-git commit -m "Pushed automatically"
	touch $@
	touch commit.time

pull: commit.time
	git pull
	touch $<

up.time: commit.time
	git pull
	git push -u origin $(BRANCH)
	touch $@

## up.time syncs as long as it's out of date, so this should work
sync: 
	$(RM) up.time
	$(MAKE) up.time

newpush: commit.time
	git push -u origin $(BRANCH)

addsync: $(add_cache)
	touch Makefile
	$(MAKE) sync

tsync:
	touch Makefile
	$(MAKE) sync

msync: commit.time
	git checkout master
	$(MAKE) sync

######################################################################

## Older module based stuff
## Need to make hybrid?

## Recursive make-based sync. 
## NOT TESTED (and not needed?)
## Work on an autosync first and then recurse that?
rmsync: $(mdirs:%=%.rmsync) makestuff.msync commit.time
	git checkout master
	$(MAKE) sync
	git status

### up
### Why is this better than a foreach approach?
### I guess because I control the order.
### Probably some hybrid approach would be best...

rup: $(mdirs:%=%.rup) makestuff.up up.time

mup: master up.time

bump: makestuff.up up.time

%.up: %
	cd $< && $(MAKE) up.time

## The alternative is for bootstrapping
%.rup: %
	cd $< && ($(MAKE) rup || $(MAKE) makestuff.pull)

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

%.msync: %.master %.sync ;
%.sync: %
	cd $< && $(MAKE) sync

%.pull: %
	cd $< && $(MAKE) pull

%.push: %
	cd $< && $(MAKE) up.time

## git_check is probably useful for some newer rules …
git_check = git diff-index --quiet HEAD --

######################################################################

## git push; make things and add them to the repo
## Testing streamlined version Jul 2017

%.gp: % git_push
	cp $* git_push
	git add -f git_push/$*
	touch Makefile

git_push:
	$(mkdir)

######################################################################

## Pages. Sort of like git_push, but for gh_pages (html, private repos)
## May want to refactor as for git_push above (break link from pages/* to * for robustness)

%.pages:
	$(MAKE) pages/$*
	cd pages && git add -f $* && git commit -m "Pushed from parent" && git pull && git push

pages/%: % pages
	cd pages && git checkout gh-pages
	$(copy)

pages:
	git clone `git remote get-url origin` $@
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

.ignore:
	-/bin/cp $(ms)/ignore.default $@

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

### make gittest.mk
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

%.localtest: % %.localdir %.dirtest ;

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

## Is this one the problem?
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
newstuff:
	git submodule foreach --recursive 'ls -d makestuff || git pull'

## Clumsily sync after doing that
## This goes through directories that have makestuff and adds and commits just the makestuff
## Should have something else to autosync the makestuff directories
comstuff:
	git submodule foreach --recursive '(ls -d makestuff && make syncstuff) ||: '

comcom: 
	git submodule foreach --recursive '(ls -d makestuff && make tsync) ||: '

getstuff: git_check newstuff comstuff

syncstuff: makestuff
	git add $< 
	git commit -m $@

getstuff: git_check newstuff comstuff

## Watch out for the danger of committing without syncing. The higher-level repos may be more up-to-date than the lower ones…

## Better would be a hybrid approach.
## A make rule that uses foreach (without --recursive) to recurse on itself
## Keep newstuff to develop and push the more sophisticated stuff

######################################################################

## Unified hybrid stuff (HOT)

## Push everything to repo
hup: $(mdirs:%=%.hup) $(clonedirs:%=%.hup) makestuff.hup up.time

Ignore += *.hup
makestuff.hup: %.hup: $(wildcard %/*.*)
	((cd $* && $(MAKE) up.time) && touch $@)
## Tortured logic is only for propagation of makestuff
## Maybe suppress
%.hup: $(wildcard %/*.*)
	((cd $* && $(MAKE) hup) && touch $@) || (cd $* && ($(MAKE) makestuff.msync || $(MAKE) makestuff.sync))

## Push makestuff changes to subrepos
srstuff:  $(mdirs:%=%.srstuff) $(clonedirs:%=%.srstuff)

%.srstuff:
	cd $*/makestuff && git checkout master && $(MAKE) pull

## Clones and hybrids

%.cloneup:
	cd $* && $(MAKE) cloneup

cloneup: $(clonedirs:%=%.cloneup) up.time ;

%.makeclone: % 
	cd $* && $(MAKE) makestuff && $(MAKE) makeclones

makeclones: $(clonedirs:%=%.makeclone) ;

## Transitional, doesn't recurse (yet?)

## Just pull
cpstuff: makestuff.sync $(clonedirs:%=%.cpstuff) ;

%.cpstuff: 
	cd $* && $(MAKE) makestuff.pull

## Sync (works on older things than cpstuff will. I hope)
csstuff: makestuff.push $(clonedirs:%=%.csstuff) ;

%.csstuff: 
	cd $* && $(MAKE) makestuff.msync && $(MAKE) csstuff

######################################################################

## New repos
## We should have separate lines for different kinds:
## master (postpone)

## Not tested; want to make a working repo soon!
## container
%.newcontainer: %.containerfiles %.first

%.containerfiles: %
	! ls $*/Makefile || (echo new files: Makefile exists; return 1)
	cp $(ms)/hybrid/container.mk $*/Makefile
	cp $(ms)/hybrid/upstuff.mk $(ms)/target.mk $*

## working
%.newwork: %.workfiles %.first ;

%.workfiles: %
	! ls $*/Makefile || (echo new files: Makefile exists; return 1)
	echo "# $*" > $*/Makefile
	cat $(ms)/hybrid/work.mk >> $*/Makefile
	cp $(ms)/hybrid/substuff.mk $(ms)/target.mk $*

%.first:
	cd $* && $(MAKE) makestuff && $(MAKE) commit.default && $(MAKE) newpush

## Old

%.newhybrid: % %.hybridfiles
	cd $* && make makestuff

%.hybridfiles: %
	! ls $*/Makefile || (echo newhybrid: Makefile exists; return 1)
	cp $(ms)/makefile.mk $*/Makefile
	cp $(ms)/hybrid/makestuff.mk $(ms)/target.mk $*

%/Makefile %/link.mk %/target.mk %/sub.mk:
	$(CP) $(ms)/$(notdir $@) $*/

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
	git checkout $(subst .,,$(suffix $*)) -- $(basename $*)
	cp $(basename $*) $@
	$(MV) tmp_$(basename $*) $(basename $*)

## Chaining trick to always remake
%.olddiff: %.old.diff ;
%.old.diff: %
	-$(DIFF) $* $*.*.oldfile > $*.olddiff

######################################################################

## Git config (just to remind myself)

store_all:
	git config --global credential.helper 'store'
