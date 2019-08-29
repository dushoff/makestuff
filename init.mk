gitroot = ./
export ms = $(gitroot)/makestuff

%/target.mk:
	-cp makestuff/target.mk $@

%/sub.mk:
	-cp makestuff/sub.mk $@

%/stuff.mk:
	-cp makestuff/stuff.mk $@

%/Makefile:
	echo "# $*" > $@
	cat makestuff/hooks.mk >> $@
	cat makestuff/makefile.mk >> $@
		cd $* && $(MAKE) Makefile

