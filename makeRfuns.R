
## Utilities
targetname <- function(ext="", suffix="\\.Rout", fl = commandArgs(TRUE)[[1]]){
	return(sub(suffix, ext, fl))
}

## Just selects extensions, not clear that it's good (used for legacy)
fileSelect <- function(fl = commandArgs(TRUE), exts)
{
	outl <- character(0)
	for (ext in exts){
		if(grepl("\\.", ext))
			warning("Extension", ext, "starts with . in fileSelect")
		ss <- paste0("\\.", ext, "$")
		outl <- c(outl, grep(ss, fl, value=TRUE))
	}
	return(outl)
}

matchFile <-  function(pat, fl = commandArgs(TRUE)){
	f <- grep(pat, fl, value=TRUE)
	if (length(f) == 0) die("No match for", pat, "in", fl)
	if (length(f) > 1) die("More than one match for", pat, "in", fl)
	return(f)
}

### Loading and reading

## This is meant to be a default starting point for $(makeR) scripts
## wrapmake encodes the current defaults for $(run-R) scripts
commandFiles <- function(fl = commandArgs(TRUE), gr=TRUE){
	commandEnvironments(fl)
	commandLists(fl)
	if(gr) makeGraphics()
	sourceFiles(fl, first=FALSE)
}

## Source certain files from a file list
sourceFiles <- function(fl=commandArgs(TRUE) 
	, exts=c("R", "r"), first=TRUE)
{
	fl <- fileSelect(fl, exts)
	if (!first) fl <- fl[-1]
	for (f in fl){
		source(f)
	}
}

## Read environments from a file list to a single environment
commandEnvironments <- function(fl = commandArgs(TRUE)
	, exts = c("RData", "rda", "rdata"), parent=.GlobalEnv
)
{
	envl <- fileSelect(fl, exts)
	loadEnvironments(envl, parent)
	invisible(envl)
}

csvRead <- function(pat, fl = commandArgs(TRUE), ...){
	return(readr::read_csv(matchFile(pat, fl), ...))
}

csvReadList <- function(pat, fl = commandArgs(TRUE), ...){
	return(lapply(grep(pat, fl, value=TRUE)
		, function(fn){readr::read_csv(fn, ...)}
	))
}

## Read rds lists from a file list to a single environment
commandLists <- function(fl = commandArgs(TRUE)
	, exts = c("Rds", "rds"), parent=.GlobalEnv
)
{
	varl <- fileSelect(fl, exts)
	loadVarLists(varl, parent)
	invisible(varl)
}

## Wrapper for legacy makefiles
## By default takes Rout dependencies and assumes rda environments
legacyEnvironments <- function(fl = commandArgs(TRUE)
	, dep = "Rout", ext="rda")
{
	envl <- fileSelect(fl, dep)
	if(length(envl>1)){
		ss <- paste0(dep, "$")
		envl <- sub(ss, ext, envl[-1])
	}
	loadEnvironments(envl)
	invisible(envl)
}

## Read environments from a file list to separate places
## NOT implemented

## Load every environment found into GlobalEnv
## This is the simple-minded default
loadEnvironments <- function(envl, parent=.GlobalEnv)
{
	for (env in envl){
		load(env, parent)
	}
}

## Load every list found into GlobalEnv
## This is the efficient rds analogue of the simple-minded default
loadVarLists <- function(varl, parent=parent.frame())
{
	for (v in varl){
		l <- readRDS(v)
    	list2env(l, envir=parent)
	}
}

#### Graphics

makeGraphics <- function(...
	, target = commandArgs(TRUE)[[1]]
	, otype = NULL, ext = otype
)
{
	if(is.null(ext)) ext = "pdf.tmp"
	if(is.null(otype)) otype = "pdf"
	fn <- paste0(target, ".", ext)
	graphics.off()
	get(otype)(..., file=fn)
}

#### Saving

saveEnvironment <- function(target = targetname(), ext="rda"){
	save.image(file=paste(target, ext, sep="."))
}

saveVars <- function(..., target = targetname(), ext="rdata"){
	save(file=paste(target, ext, sep="."), ...)
}

## FIXME: I have the wrong environment for objects
saveList <-  function(..., target = targetname(), ext="rds"){
	l <- list(...)
	if(length(l)==0){
		names <- objects(parent.frame())
	} else {
		names <- as.character(substitute(list(...)))[-1]
	}

	outl <- list()
	for (n in names){
		outl[[n]] <- get(n)
	}
	saveRDS(outl, file=paste(target, ext, sep="."))
	return(invisible(names(outl)))
}
