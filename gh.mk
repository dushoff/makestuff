
initBranch ?= main
.git:
	git init -b $(initBranch)

## USE github_private or github_public to make a repo named after directory
github_%: | .git commit.time
	gh repo create --$* --source=. --push

## USE github_private or github_public to make a repo named after directory
github_%: | .git commit.time
	gh repo create --$* --source . --push

## More flexible version?? Doesn't match origin somehow. What is origin?
ghrepo_%: | .git commit.time
	gh repo create $(repoName) --$* --source=. --remote=upstream --push


