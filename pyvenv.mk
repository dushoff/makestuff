## Put this BEFORE python.def to get the definitions to work
pypath =  pyvenv
Ignore += pyvenv __pycache__
Makefile: | pyvenv

cleanpyvenv = python -m venv pyvenv
systempyvenv = python -m venv --system-site-packages pyvenv

## Add one of these to your makefile
## pyvenv: ; $(cleanpyvenv)
## pyvenv: ; $(systempyvenv)
	
Ignore += *.pip
.PRECIOUS: %.pip
%.pip:
	pyvenv/bin/pip install $* && $(touch)
	$(touch)

venvclean:
	$(RMRF) *.pip pyvenv
