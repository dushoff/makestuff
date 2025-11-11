texj.mk is an attempt to rebuild the functionality of texi.mk without using texi tools, which have weird CLI and don't account for changes in .bib files anyway.

I still have some confusion about what would be the most efficient way to deal with interactions between building steps, but it seems to work OK for an early attempt.

To make `filename.pdf`, it first attempts to make included files (via filename.tex.mk), then to force-make the .aux file (the .pdf file can be made as a side-effect, but won't be seen as successfully made). It then tries again (via a rule for .repeat). This rule will mark the .aux as new based on messages in the .log (right now looks only for "Rerun to"). The pipeline should tell you at the end whether “latex refs [are] up to date” or else give you some kind of rerun message.

On subsequent attempts, filename.pdf is never considered up to date. This is because the main Makefile can't easily know about all of the calculated dependencies. But if dependencies are up to date, and the pdf is newer than the .aux, make won't actually do anything, just some checking.

To see what kind of pdf is being made, you can just examine a side-effect filename.pdf, but the make-y way to do it is to make and visualize `filename.force.pdf`.

To put an output pdf in a real pipeline, it is recommended to use `filename.complete.pdf` – this will repeat the main make step until it thinks all of the references are up to date.

If there are input or include dependencies, texj will automatically make required files, but does not automatically look at their dependencies. This is because of a chicken-and-egg problem.

The recommended practice is to include a line in your Makefile that make can trace along and try to get all of your dependencies:
`outer.texdeps.mk: inner.texdeps.mk`. This is meant to work recursively.

Warning: If you find some other way to get the text “Rerun to” into the tex log file, the rules will exhibit persistently annoying behaviour.

## To do

The logic of what files to make when is not very well thought-out and not very beautiful (this is the distinction between .files, made at the beginning, and the full set of dependencies .deps, made subsequently). This logic is implemented in texj.pl, and may not even be necessary at all.

It would be nice maybe to have a robust way of getting the bibliography stuff to compile even when picture dependencies are not ready.

.bbl should be made to depend on something, for applications where .bbl is being used for something else. pdf would presumably be a loop, but something inside.
