texj.mk is an attempt to rebuild the functionality of texi.mk without using texi tools, which have weird CLI and don't account for changes in .bib files anyway.

I still have some confusion about what would be the most efficient way to deal with interactions between building steps, but it seems to work OK for an early attempt.

To make <filename>.pdf, it first attempts to make included files (via filename.tex.mk), then to force-make the .aux file (the .pdf file can be made as a side-effect, but won't be seen as successfully made). It then tries again (via a rule for .repeat). This rule will mark the .aux as new based on messages in the .log (right now looks only for "Rerun to").

On subsequent attempts, filename.pdf is never considered up to date. This is because the main Makefile can't easily know about all of the calculated dependencies. But if dependencies are up to date, and the pdf is newer than the .aux, make won't actually do anything, just some checking.
