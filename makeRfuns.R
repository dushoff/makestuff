
## Utilities

##' what does the function do?
##'
##' @param ext file extension for output
##' @param suffix file extension of provided name
##' @param fn provided file name (first of commandArgs by default)
##' @export
targetname <- function(ext="", suffix="\\.Rout", fn = makeArgs()[[1]]){
	return(sub(suffix, ext, fn))
}

## Improved 2020 Sep 10 (Thu)
## Argument order is still kind of legacy
fileSelect <- function(fl = makeArgs(), exts=NULL, pat=NULL)
{
	if(!is.null(exts)){
		outl <- character(0)
		for (ext in exts){
			if(grepl("\\.", ext))
				warning("Extension", ext, "starts with . in fileSelect")
			ss <- paste0("\\.", ext, "$")
			outl <- c(outl, grep(ss, fl, value=TRUE))
		}
		fl <- outl
	}
	if (!is.null(pat))
		fl <- grep(pat, fl, value=TRUE)
	return(fl)
}

matchFile <-  function(pat, fl = makeArgs(), exts=NULL){
	f <- fileSelect(fl, exts, pat)
	if (length(f) == 0) stop("No match for ", pat, " in ", fl)
	if (length(f) > 1) stop("More than one match for ", pat, " in ", fl)
	return(f)
}

makeArgs <- function(){
	if(interactive()){
		if (!exists("callArgs"))
			stop("Define callArgs to use makeR files; see .args file?")
		return(strsplit(callArgs, " ")[[1]])
	}
	return(commandArgs(TRUE))
}
### Loading and reading

## This is now deprecated; refer to these steps, but do them manually.
## wrapmake encodes the current defaults for $(run-R) scripts
commandFiles <- function(fl = makeArgs(), gr=TRUE){
	commandEnvironments(fl)
	commandLists(fl)
	sourceFiles(fl, first=FALSE, verbose=FALSE)
	if(gr) makeGraphics()
}

## Source certain files from a file list
sourceFiles <- function(fl=makeArgs() 
	, exts=c("R", "r"), first=FALSE, verbose=FALSE)
{
	fl <- fileSelect(fl, exts)
	if (!first) fl <- fl[-1]
	for (f in fl){
		source(f, verbose=verbose)
	}
}

## What are the advantages of .GlobalEnv vs parent.frame()?
## Read environments from a file list to a single environment
commandEnvironments <- function(fl = makeArgs()
	, exts = c("RData", "rda", "rdata"), parent=.GlobalEnv
)
{
	envl <- fileSelect(fl, exts)
	loadEnvironments(envl, parent)
	invisible(envl)
}

getEnvironment <- function(pat="", fl = makeArgs()
	, exts = c("RData", "rda", "rdata")
)
{
	ff <- fileSelect(fl, exts)
	f <- matchFile(pat, ff)
	e <- new.env()
	load(f, e)
	return(e)
}

## Developing 2020 Aug 03 (Mon)
loadRdsList <- function(fl = makeArgs()
	, exts = "rds", names=NULL
	, trim = "\\.[^.]*$"
){
	rf <- fileSelect(fl, exts)
	if(is.null(names)){
		names = sub(trim, "", rf)
	}
	stopifnot(length(names)==length(rf))
	rl <- list()
	for (i in 1:length(rf)){
		rl[[names[[i]]]] <- readRDS(rf[[i]])
	}
	return(rl)
}

loadEnvironmentList <- function(pat = NULL
	, fl = makeArgs()
	, exts = c("RData", "rda", "rdata")
	, names=NULL, trim = "\\.[^.]*$"
)
{
	envl <- fileSelect(fl, exts, pat)
	if(is.null(names)){
		names = sub(trim, "", envl)
	}
	stopifnot(length(names)==length(envl))
	el <- list()
	if(length(envl)==0)
	{
		warning("No environments matched in loadEnvironmentList")
		return(NULL)
	}
	for (i in 1:length(envl)){
		el[[i]] <- new.env()
		load(envl[[i]], el[[i]])
	}
	names(el) <- names
	return(el)
}

## having readr:: means that readr must be in Imports: in the DESCRIPTION file
##' @importFrom readr read_csv  ## this is redundant with 'readr::'
csvRead <- function(pat="csv$", fl = makeArgs(), ...){
	return(readr::read_csv(matchFile(pat, fl), ...))
}

tsvRead <- function(pat="tsv$", fl = commandArgs(TRUE), ...){
	return(readr::read_tsv(matchFile(pat, fl), ...))
}

## This should take extensions and be less slick (make the list as a separate step)
csvReadList <- function(pat, fl = makeArgs(), ...){
	return(lapply(grep(pat, fl, value=TRUE)
		, function(fn){readr::read_csv(fn, ...)}
	))
}

## Wrapper for legacy makefiles
## By default takes Rout dependencies and assumes rda environments
legacyEnvironments <- function(fl = makeArgs()
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

## Load a list of environments
loadEnvironments <- function(envl, parent=.GlobalEnv)
{
	for (env in envl){
		load(env, parent)
	}
}

#### Graphics

makeGraphics <- function(...
	, target = makeArgs()[[1]]
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

saveVars <- function(..., target = targetname(), ext="rda"){
	save(file=paste(target, ext, sep="."), ...)
}

rdsSave <- function(vname, target = targetname(), ext="rds"){
	saveRDS(vname, file=paste(target, ext, sep="."))
}

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

### Output

csvSave <- function(..., target = targetname(), ext="Rout.csv"){
	write.csv(file=paste(target, ext, sep="."), ...)
}
