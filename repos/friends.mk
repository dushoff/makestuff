
## PulliamLab-UFL
## https://github.com/PulliamLab-UFL/competenceFramework.git

## Lord competence
PulliamLab += competenceFramework

$(PulliamLab):
	$(MAKE) target=$@ repo=$(github) user=PulliamLab-UFL clone

repodirs += $(PulliamLab)

######################################################################

## Mike Li

## Something hacked together for Katie and Rachel
wzmli += rabies_report

## Mike's big Scotland idea
wzmli += rabies_correlations

## 2018 Jun 07 (Thu) the current rabies_R0 investigation (Scotland poster)
wzmli += rabies_R0

$(wzmli):
	$(MAKE) target=$@ repo=$(github) user=wzmli clone

repodirs += $(wzmli)


######################################################################

## ICI3D

ICI3D += MMED MMEDparticipants ICI3D.github.io coreFaculty RTutorials

ICI3D += Malaria malariaImmunity

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

## Mac theobio organization

theobio += QMEE smb-mathepi

$(theobio):
	$(MAKE) target=$@ repo=$(github) user=mac-theobio clone

repodirs += $(theobio)

######################################################################

# alejo = PISKa_disease_modeling
# roxy = SIHR-Age-Mixing-Analysis
# dsw_github = networkSEIR
# sid_reed = DushoffCollab
# mli_github = Survival rdc mli_sims HIV_Coupling lunchbox hybrid hybrid2 mc_recency StrucImpute Li_Rabies mc_status comps hybridx rabies_R0
# wim_github = MiceABC
# earn = plague
# PulliamLab = competenceFramework
# worden_github = github-pages-sandbox 

# walker_bitbucket = goaheadandrarefymicrobiomedata
# bolker_github = microbiome_stats upr_2016 HIV_LHS mosqsamp stat744
# blank = dhsease
# pearsonca = alice bob carl karl
# woodstkp_github = Woodstock-thesis
# bellan_github = IDI-cumulative-VL-project
# dc = RESuDe_forecast epiforecast
# fishforwish = fgc
# elia_github = Sequels

# roswell = SexNetworks_git

