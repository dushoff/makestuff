What are the different possible approaches to stepping?

All the time
============

Make makefiles before running; use them all the time

Just in time
============

Make makefiles as a side-effect; use only makefiles that you know you need

In-between
==========

Make makefiles all the time, but control when you use them

Each approach has different problems, and it seems like we could go pretty far down this rabbit hole

----------------------------------------------------------------------

The big problem we had before with All the time approaches is that a client (me) was making .tex files. Haven't seen a case where I would want to make .R files, though...

So we should consider making all of the .rdeps files right at the beginning.

Next: do we always use them? Well, why not?

----------------------------------------------------------------------

Try 1
=====

Be violent!

Or … allow the user to specify stepFiles. stepFiles always use the .rdeps files to be made. But the problem here is you can't really specify static targets with patterns unless they exist. So, violent for now.

Could also have rules for types of files...
e.g.,
$(routs):
	$(MAKE) -f Makefile -f *.rdeps $@
But not yet.

Conventions:

.RData is made automatically; matches R script name

.rda should be made manually and parsed out by rstep.pl

Ha! There also seem to be chaining problems?

----------------------------------------------------------------------

## Figures: should be parsing these out when made manually (include ggsave)

Deal with Rplots.pdf

Are there other auto figures? What's the default?

* Looks for input/output filenames using keywords (like read_*, ggsave) and then finding the first thing in parens surrounded by quotes.
* Puts the natural dependency into .rdeps

* Use <line> # noStep to ignore something
* Use # stepSource/stepProduct to manually add to rdeps
