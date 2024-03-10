In general, inferring make rules (stepR) is harder than using make to tell R what to do (makeR). Maybe don't bother to do it?

Top-down
* Make a bunch of .mk files (one for each .R file). Do this with make's continue-after-error thing
* Do this as a dependency of Makefile? Or of every .Rout?

Just-in-time
* Make and evaluate .mk files for each file that is being run.
* How does this interact with downstream outputs (like pdf)?
* How do we get up-to-date when things change?

2023 Nov 12 (Sun)

Let's try top-down from Makefile. That will allow scanning all changes and recognizing how to make weird pdf files, for example.
