## Put this BEFORE python.def to get the definitions to work
pypath =  pyvenv
Ignore += pyvenv __pycache__
Makefile: | pyvenv

## Clean virtual environment
cleanpyvenv = python -m venv pyvenv
systempyvenv = python -m venv --system-site-packages pyvenv

## pyvenv: ; $(cleanpyvenv)
## pyvenv: ; $(systempyvenv)
	
Ignore += *.pip
.PRECIOUS: %.pip
%.pip:
	pyvenv/bin/pip install $* && $(touch)
	$(touch)
