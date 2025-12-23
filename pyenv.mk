## Deprecated, see pyvenv.mk
## pypath =  pyenv | pyvenv ## pick one for your Makefile
Ignore += $(pypath) __pycache__
Makefile: | $(pypath)

## Clean virtual environment
pyvenv:
	python -m venv $@

## Lazy virtual environment
pyenv:
	python -m venv --system-site-packages $@
	
Ignore += *.pip
.PRECIOUS: %.pip
%.pip:
	$(pypath)/bin/pip install $* && $(touch)
	$(touch)

