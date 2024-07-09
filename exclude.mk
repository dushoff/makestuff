## Ignoring

## Find the git directory and make an exclude file here
## Subdirectories compete (overwrite each others' exclude files)
## I'm not planning to solve this 2021 May 14 (Fri); use git status .
## It might help to let subdirectories inherit Ignore (don't use plain = at top)

git_dir = $(shell git rev-parse --git-dir)

exclude = $(git_dir)/info/exclude
exclude: $(exclude) ;

reignore:
	$(RM) $(exclude)
	$(MAKE) ignore
ignore:
	$(MAKE) exclude
	git status .

## Usually .git/info/exclude
## dirdir ../.git/info/exclude
$(git_dir)/info/exclude: Makefile $(Sources)
	perl -wf makestuff/ignore.pl > $@ || perl -wf ignore.pl > $@

export Ignore += local.mk target.mk make.log go.log tmp.scr background.log

## Make global ignore file on a new machine
config_ignore = makestuff/ignore.vim makestuff/ignore.auth makestuff/ignore.lock
ignore.config: ~/.config/git
	cat $(config_ignore) > $</ignore

## Make a .gitignore file with what usually goes into exclude
ignorehere: $(git_dir)/info/exclude
	$(CP) $< .gitignore
