## Put this BEFORE python.def to get the definitions to work
## Add one of these to your makefile
## pyvenv: ; $(cleanpyvenv)
## pyvenv: ; $(systempyvenv)
	
pypath =  pyvenv
Ignore += pyvenv __pycache__

cleanpyvenv = python -m venv pyvenv
systempyvenv = python -m venv --system-site-packages pyvenv

Ignore += *.pip *.lpip
.PRECIOUS: %.pip
%.pip: | pyvenv
	pyvenv/bin/pip install $*
	$(touch)

## Probably want an .lpip rule with just ./$*…

pyenvclean venvclean:
	$(RMRF) *.pip pyvenv pyenv
