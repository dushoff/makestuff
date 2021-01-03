makerURL = https://github.com/ComputationalProteomicsUnit/maker.git

Makefile: maker
Ignore += maker
maker:
	(ls -d ../maker && ln -s ../maker .) \
	|| (ls -d ../../maker && ln -s ../../maker .) \
	|| git clone $(makerURL)

mr_%:
	make $* -f maker/Makefile MAKERMAKEFILE=maker/Makefile PKGDIR=.

