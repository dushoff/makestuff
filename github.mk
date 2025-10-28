## Randomly spun 2025 Oct 27 (Mon)
## Need to make it make-y or something
## The JSON return text is terrible
add_bolker:
	gh api \
	--method PUT \
	-H "Accept: application/vnd.github+json" \
	/repos/dushoff/nsercMixing/collaborators/bbolker \
	-f permission=push

check_bolker:
	gh api /repos/dushoff/nsercMixing/invitations

