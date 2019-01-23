include $(ms)/repos/friends.def

repodirs += $(links)

$(PulliamLab):
	$(MAKE) target=$@ repo=$(github) user=PulliamLab-UFL clone
repodirs += $(PulliamLab)

$(cygubicko):
	$(MAKE) target=$@ repo=$(github) user=cygubicko clone
repodirs += $(cygubicko)

$(wzmli):
	$(MAKE) target=$@ repo=$(github) user=wzmli clone
repodirs += $(wzmli)

$(ICI3D):
	$(MAKE) target=$@ repo=$(github) user=ICI3D clone
repodirs += $(ICI3D)

$(davidchampredon):
	$(MAKE) target=$@ repo=$(github) user=davidchampredon clone
repodirs += $(davidchampredo)

$(davidearn):
	$(MAKE) target=$@ repo=$(github) user=davidearn clone
repodirs += $(davidearn)

$(bolker_github):
	$(MAKE) target=$@ repo=$(github) user=bbolker clone
REPODirs += $(bolker_github)

$(fishforwish):
	$(MAKE) target=$@ repo=$(github) user=fishforwish clone
repodirs += $(fishforwish)

$(cfshi):
	$(MAKE) target=$@ repo=$(github) user=cfshi clone
repodirs += $(cfshi)

## Mac theobio organization

$(theobio):
	$(MAKE) target=$@ repo=$(github) user=mac-theobio clone
repodirs += $(theobio)

$(parksw3):
	$(MAKE) target=$@ repo=$(github) user=parksw3 clone
repodirs += $(parksw3)

## Fix this with a drop-in (clone-in)
Ignore += $(champredon)
$(champredon):
	$(MAKE) target=$@ repo=$(github) user=davidchampredon clone

repodirs += alberta_age
alberta_age:
	git clone https://git.overleaf.com/8974471gkzqmdgbwvtj $@

## Roswell

$(mikeroswell):
	$(MAKE) target=$@ repo=$(github) user=mikeroswell clone
repodirs += $(mikeroswell)

## Outbreak-analysis (see dushoff_repos.mk)
