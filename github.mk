## Randomly spun 2025 Oct 27 (Mon)
## Need to make it make-y or something
## The JSON return text is terrible

ghput = gh api --method PUT
jsonaccept = Accept: application/vnd.github+json

Ignore += *.invite
## This could be generalized to other roles, e.g.
## %.push.invite:
%.invite: makestuff/github.mk
	$(ghput) repos/$(repoonly)/collaborators/$* \
	-f permission=push > $@

## checkgh: checkgh.log
checkgh:
	gh api repos/$(repoonly)/invitations > $@.log

