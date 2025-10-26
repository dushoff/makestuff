## pypath =  pyenv | pyvenv ## pick one for your Makefile
Makefile: | $(pypath)

## Clean virtual environment
pyvenv:
	python -m venv $@

## Lazy virtual environment
pyenv:
	python -m venv --system-site-packages $@
	
Ignore += *.pip
%.pip:
	$(pypath)/bin/pip $* && $(touch)

