
### Git for _centralized_ workflow
### Trying to generalize now

cmain = dev

BRANCH = $(shell cat .git/HEAD | perl -npE "s|.*/||;")

newpush: commit.txt
	git push -u origin $(BRANCH)

push: commit.txt
	git push

pull: commit.txt
	git fetch
	git rebase origin/$(BRANCH)
	touch $<

continue: $(Sources)
	git add $(Sources)
	git rebase --continue

#### Branching ####

### Trees are green

%.branch:
	$(MAKE) commit.txt
	git checkout $*

%.newbranch:
	-git branch -d $*
	git branch $*
	$(MAKE) $*.branch
	$(MAKE) newpush

%.nuke:
	git branch -D $*
	git push origin --delete $*

## FrogS!

updatebranch: sync
	git rebase $(cmain) 

fullmerge: updatebranch
	git pull
	git checkout $(cmain)
	git pull
	git pull origin $(BRANCH)
	git push

future:
	git branch -d $(BRANCH)
	git push origin --delete $(BRANCH)

abort: 
	git rebase --abort

sync: 
	$(MAKE) pull
	$(MAKE) push

commit.txt: $(Sources)
	git add $(Sources)
	echo "Autocommit ($(notdir $(CURDIR)))" > $@
	-git commit --dry-run >> $@
	gvim -f $@
	-git commit -F $@
	date >> $@

.gitignore:
	-/bin/cp $(ms)/$@ .

README.md:
	-/bin/cp $(ms)/README.github.md $@
	touch $@

LICENSE.md:
	touch $@

remove:
	git rm $(remove)

forget:
	git reset --hard

# Clean all unSourced files (files with extensions only) from directory or repo
clean_repo:
	git rm --cached --ignore-unmatch $(filter-out $(Sources), $(wildcard *.*))

clean_dir:
	-$(RMR) .clean_dir
	mkdir .clean_dir
	$(MV) $(filter-out $(Sources) local.mk $(wildcard *.makestuff), $(wildcard *.*)) .$@

clean_both: clean_repo clean_dir

$(Outside):
	echo You need to get $@ from somewhere outside the repo and try again.
	exit 1

# Test that you can make the current target with the Sources and the rules

testdir: $(Sources)
	-/bin/rm -rf .$@
	-/bin/mv -f $@ .$@
	mkdir $@
	mkdir $@/$(notdir $(CURDIR))
	tar czf $@/$(notdir $(CURDIR))/export.tgz $(Sources)
	cd $@/$(notdir $(CURDIR)) && tar xzf export.tgz
	-/bin/cp local.* $@/$(notdir $(CURDIR)) 
	cd $@/$(notdir $(CURDIR)) && $(MAKE)

subclone:
	$(MAKE) push
	-/bin/rm -rf subclone_dir
	mkdir subclone_dir
	cd subclone_dir && grep url ../.git/config | perl -npe "s/url =/git clone/; s/.git$$//" | sh
	cd subclone_dir/* && $(MAKE) Makefile && $(MAKE)

local.mk:
	-/bin/cp $(gitroot)/local/local.mk .
	touch $@
