source("makestuff/makeRfuns.R")

commandEnvironments()
legacyEnvironments()
commandEnvirLists()
## commandVarLists(fl)

makeGraphics()

input_files <- fileSelect(commandArgs(TRUE), 
	c("csv", "tsv", "ssv", "txt")
)

rtargetname <- targetname()
csvname <- paste0(rtargetname, ".Rout.csv")
rdsname <- paste0(rtargetname, ".Rds")
rdaname <- paste0(rtargetname, ".rda")

sourceFiles(first=TRUE)

saveEnvironment()
