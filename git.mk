### Git for _centralized_ workflow
### Trying to generalize now

cmain = NULL

ifndef BRANCH
BRANCH=master
endif

-include $(BRANCH).mk

##################################################################

### Push and pull

branch:
	@echo $(BRANCH)

newpush: commit.time
	git push -u origin master

push: commit.time
	git push -u origin $(BRANCH)

pull: commit.time
	git pull
	touch $<

rebase: commit.time
	git fetch
	git rebase origin/$(BRANCH)
	touch $<

sync:
	$(MAKE) rebase
	$(MAKE) push

psync:
	$(MAKE) pull
	$(MAKE) push

## Use Archive with wildcard, for things that it will archive if they are there
## Other things that you want in the repo (things you want to have made automatically) are sources
commit.time: $(Sources)
	git add -f $^ $(Archive)
	echo "Autocommit ($(notdir $(CURDIR)))" > $@
	-git commit --dry-run >> $@
	gvim -f $@
	-git commit -F $@
	date >> $@

######################################################################

## Don't like git_products; makes it hard to make and sync
## Deprecate

## If you make things in git_products, they will be remade and archived each time you update the repo. 
## Use rm to stop the process
## Use git rm to take something out of the repo version
## Should be improved, obviously

git_products = $(wildcard git_products/*)
commit.time: $(git_products)
git_products/%: % git_products
	$(copy)
git_products:
	$(mkdir)

######################################################################

## git push; make things and add them to the repo

%.gp:
	$(MAKE) git_push/$*
	git add -f git_push/$*
	touch Makefile

git_push/%: % git_push
	$(copy)

git_push:
	$(mkdir)

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

README.md:
	-/bin/cp $(ms)/README.github.md $@
	touch $@

LICENSE.md:
	touch $@

##################################################################

### Cleaning

remove:
	git rm $(remove)

forget:
	git reset --hard

# Clean all unSourced files (files with extensions only) from directory and repo
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

testdir: $(Sources)
	$(maketest)
	$(testdir)

localdir: $(Sources) $(wildcard local.*)
	$(maketest)
	$(lcopy)
	$(testdir)

subclone_dir: $(Sources) 
	$(subclone)

subclone: $(Sources) 
	$(subclone)
	$(testdir)

maketest: $(Sources)
	$(maketest)

define maketest
	-/bin/rm -rf .$@
	-/bin/mv -f $@ .$@
	mkdir $@
	mkdir $@/$(notdir $(CURDIR))
	tar czf $@/$(notdir $(CURDIR))/export.tgz $(Sources)
	cd $@/$(notdir $(CURDIR)) && tar xzf export.tgz
endef

lcopy = -/bin/cp local.* $@/$(notdir $(CURDIR))

testdir = cd $@/$(notdir $(CURDIR)) && $(MAKE) Makefile && $(MAKE) && $(MAKE) vtarget

define subclone
	$(MAKE) push
	-/bin/rm -rf subclone_dir
	mkdir $@
	cd $@ $* && grep url ../.git/config | perl -npe "s/url =/git clone/; s/.git$$//" | sh
endef

##################################################################

# Branching
%.newbranch:
	git checkout -b $*
	$(MAKE) commit.time
	git push -u origin $(BRANCH)

%.branch: sync
	git checkout $*

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
