## Randomly spun 2025 Oct 27 (Mon)
## Need to make it make-y or something
## The JSON return text is terrible
addgh_%:
	gh api \
	--method PUT \
	-H "Accept: application/vnd.github+json" \
	/repos/dushoff/nsercMixing/collaborators/$* \
	-f permission=push > addgh.log

checkgh:
	gh api /repos/dushoff/nsercMixing/invitations > checkgh.log

