
## PulliamLab-UFL
## https://github.com/PulliamLab-UFL/competenceFramework.git

## Lord competence
PulliamLab += competenceFramework

$(PulliamLab):
	$(MAKE) target=$@ repo=$(github) user=PulliamLab-UFL clone

repodirs += $(PulliamLab)

######################################################################

## Mike Li

######################################################################

## ICI3D

ICI3D += MMED MMEDparticipants 

$(ICI3D):
	$(MAKE) target=$@ repo=$(github) user=ICI3D clone

repodirs += $(ICI3D)

######################################################################

## David Earn
## https://github.com/davidearn/mbfuture.git

davidearn += mbfuture

$(davidearn):
	$(MAKE) target=$@ repo=$(github) user=davidearn clone

repodirs += $(davidearn)

######################################################################

## Chyun
## https://github.com/fishforwish/fgc

fishforwish += fgc

$(fishforwish):
	$(MAKE) target=$@ repo=$(github) user=fishforwish clone

repodirs += $(fishforwish)

######################################################################

