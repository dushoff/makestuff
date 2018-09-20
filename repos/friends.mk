include $(ms)/repos/friends.def

$(PulliamLab):
	$(MAKE) target=$@ repo=$(github) user=PulliamLab-UFL clone
repodirs += $(PulliamLab)

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

Ignore += $(champredon)
$(champredon):
	$(MAKE) target=$@ repo=$(github) user=davidchampredon clone
