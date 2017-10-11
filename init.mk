gitroot = ./
export ms = $(gitroot)/makestuff

%/target.mk:
	-cp $(ms)/target.mk $@

%/sub.mk:
	-cp $(ms)/sub.mk $@

%/stuff.mk:
	-cp $(ms)/stuff.mk $@

%/Makefile:
	echo "# $*" > $@
	cat $(ms)/hooks.mk >> $@
	cat $(ms)/makefile.mk >> $@
		cd $* && $(MAKE) Makefile

