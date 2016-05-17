### Git for _centralized_ workflow
### Trying to generalize now

cmain = NULL

BRANCH = $(shell cat .git/HEAD | perl -npE "s|.*/||;")
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

##################################################################

### Rebase

continue: $(Sources)
	git add $(Sources)
	git rebase --continue

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
	$(testdir)

maketest: $(Sources)
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
