## Ignoring

## Find the git directory and make an exclude file here
## When we have subdirectories they may compete (overwrite each others' exclude files)
## Not clear why that would be a problem

git_dir = $(shell git rev-parse --git-dir)

exclude: $(git_dir)/info/exclude ;

ignore: exclude
	git status

## Usually .git/info/exclude
## dirdir ../.git/info/exclude
$(git_dir)/info/exclude: $(Sources) Makefile
	perl -wf makestuff/ignore.pl > $@ || perl -wf ignore.pl > $@

export Ignore += local.mk target.mk make.log go.log

## Make global ignore file on a new machine
ignore.config: ~/.config/git
	cat makestuff/ignore.vim makestuff/ignore.auth > $</ignore

## Make a .gitignore file with what usually goes into exclude
ignorehere: $(git_dir)/info/exclude
	$(CP) $< .gitignore
