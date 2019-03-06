## Code from HIV project pilot (lots of html pasting)

paste = makestuff/cihrScripts
Ignore += $(wildcard *.html *.mkd *.mkd.log)

######################################################################

## Trying to replace horrendosity
## Ignore count stuff for now
## Need to be able to pipe .mkd through
## Either use two rules, or make non-precious .md intermediates

%.simple.html: %.md $(paste)/simple.css
	pandoc -s -H $(paste)/simple.css -o $@ $<

%.cihr.html: %.simple.html $(paste)/cp.pl
	$(PUSH)

######################################################################

## This is horrendous. We should just accumulate suffixes
## i.e., make .cihr.html; .cihr.ccv.html …

## Old pipeline (endogenous refs)
%.auto.html: $(paste)/simple.css %.refs.mkd
	$(MAKE) $*.count
	pandoc -s -H $< -o $@ $*.refs.mkd

## New pipeline (CCV or other exogenous refs)
%.auto.html: $(paste)/simple.css %.ccv.mkd
	$(MAKE) $*.count
	pandoc -s -H $< -o $@ $*.ccv.mkd

refspage.auto.html: $(paste)/simple.css refspage.mkd
	pandoc -s -H $< -o $@ refspage.mkd

%.cp.html: %.auto.html $(paste)/cp.pl
	$(PUSH)

######################################################################

# refs

Sources += $(wildcard *.ref)

## Not clear whether we need to use this; from fancier time
## [[Integrated refs, html complete proposal]]
%.refs.mkd: %.md curr.ref $(paste)/refs.pl
	$(PUSH)
	-grep "((" $@ > $@.log
	cat $@.log

%.ccv.mkd: %.md ccv.ref $(paste)/ccv.pl
	$(PUSH)
	-grep "((" $@ > $@.log
	cat $@.log

## Counting (was probably never very reliable)

Ignore += *.count
%.count: %.out $(paste)/count.pl
	$(PUSH) || Breaks if perl.def is missing!
	cat $@

currcount:
	$(MAKE) *.count
	cat *.count

%.out: %.refs.mkd
	pandoc -t plain -o $@ $<

%.txt: %
	pandoc -t plain -o $@ $<

