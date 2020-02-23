
## 2020 Feb 22 (Sat)
## Caching stuff from git.mk that annoys me
## Think about deleting this file?

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

