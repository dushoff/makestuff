Makefile: stepper.mk

## Move stepper.pl to makestuff and delete it from this rule when things are good
steppers ?= $(wildcard *.R)
stepper.mk: $(steppers) stepper.pl
	$(PUSH)

%.Rout: %.R
	(R --vanilla  < $(word 1, $(filter %.R, $^)) > $@) || (touch $< && false)
