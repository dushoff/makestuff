
The only editable file in the pipeline is rmu, which should specify each publication with a single directive, DOI:, PMID: or PMCID:

Primary target is .tags.pgr

From  there it makes .gfm, which is designed for browsing (including clicking on pdfs), and also for getting pdfs that don't arrive automatically (using vim aliases)

Manually run .download to try some tricks to auto-download pdf files
* Decide on a library setup first (local, rclone, git) and make library/ if necessary

There is some manual stuff that tries to find DOIs, but not well integrated into flow.

----------------------------------------------------------------------

Notes on better auto-download

https://claude.ai/chat/f0f50bc8-9d3a-4ee8-80ee-65668b9fdd84

and unpaywall
