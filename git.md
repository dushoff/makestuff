Alling
======

Goal is to reliably check whether everything is up-to-date without making it impossible to pull in new stuff.

I keep going back and forth about real vs. fake targets

I think we need to have fake .all targets so that we go to the next directory and see from there whether things are up to date.

The problem is that things get stuck trying to up when they're not on branches.

So really the problem is all this goshdarned de-branching

Ignore
======

.gitignore is overrated

makestuff no uses .ignore or .gitignore natively

Things to ignore for a particular project (or a particular makestuff makefile) go into the `Ignore` variable, and then are put into an exclude file (see exclude rule)

Things to ignore everywhere (or for someone's workflow) go into a personal ignore file (see ignore.config rule)

To get along with Muggles, there is a rule 
