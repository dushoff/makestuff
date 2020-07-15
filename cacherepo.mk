## If cachestuff is a repo, you likely want these rules
## See also cacheflow.mk

Ignore += cachestuff

all.time: cachestuff.filesync

pull: cachestuff.gitpull
