-include local.mk

Ignore += local.mk
Sources += $(wildcard *.local)

%.locate: | %.local
	$(LN) $| local.mk
