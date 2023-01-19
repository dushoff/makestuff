PY ?= python3
PIP ?= pip3

pyscript = $(filter %.py, $^)
pydep = $(filter-out %.checkfile, $(filter-out %.py, $^))
# Adapted from perl.def
# Runs the first script among its dependencies, using all the other dependencies as arguments
pycall = $(PY) $(pyscript) $(pydep)
pycallout = $(PY) $(pyscript) $@ $(pydep)

PITH = ($(pycall) > $@) || ($(setcheckfile))
PITHOUT = ($(pycallout) > $@) || ($(setcheckfile))

## Is not invoked, and checkfile does nothing
%.py.out: $(call hiddenfile, %.out.checkfile)
	$(PITHOUT)

######################################################################
## OLD

# Adds the name of the output file as the first argument (assuming you only have one script dependency)
PITHOUTONLY = $(PY) $(filter %.py, $^) $@ $(filter-out %.py, $^) > $@

# Adds $*
PITHSTARONLY = $(PY) $(filter %.py, $^) $* $(filter-out %.py, $^) > $@

# Appends (pushes onto the file that's already there)
PITHONONLY = $(PY) $(filter %.py, $^) $(filter-out %.py, $^) >> $@


