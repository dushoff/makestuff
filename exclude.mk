## Ignoring

## Find the git directory and make an exclude file here
## When we have subdirectories they may compete (overwrite each others' exclude files)
## Not clear why that would be a problem

git_dir = $(shell git rev-parse --git-dir)

exclude: $(git_dir)/info/exclude ;

## Usually .git/info/exclude
## dirdir ../.git/info/exclude
$(git_dir)/info/exclude: $(Sources) Makefile
	perl -wf makestuff/ignore.pl > $@ || perl -wf ignore.pl > $@

export Ignore += local.mk target.mk make.log go.log

ignore.config: ~/.config/git
	cat makestuff/ignore.vim makestuff/ignore.auth $</ignore

ignorehere: $(git_dir)/info/exclude
	$(CP) $< ~/.gitignore
