## Code from HIV project pilot (lots of html pasting)

paste = makestuff/cihrScripts
Ignore += $(wildcard *.html *.mkd)

%.auto.html: $(paste)/simple.css %.refs.mkd
	$(MAKE) $*.count
	pandoc -s -H $< -o $@ $*.refs.mkd

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

## Counting (was probably never very reliable)

Ignore += *.count
%.count: %.out $(paste)/count.pl
	$(PUSH)
	cat $@

currcount:
	$(MAKE) *.count
	cat *.count

Ignore += refspage.mkd curr.ref
refspage.mkd curr.ref:
	touch $@

%.out: %.refs.mkd
	pandoc -t plain -o $@ $<

