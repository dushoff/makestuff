## If cachestuff is a repo, you likely want these rules
## See also cacheflow.mk

Ignore += cachestuff

up.time: cachestuff.gitpush

pullup: cachestuff.gitpull
