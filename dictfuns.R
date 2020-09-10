cleanDict <- function(keys, values){
	r <- (tibble(x=keys, n=values))
	o <- filter(r, !is.na(x) & !is.na(n))
	d <- distinct(o)
	c <- d %>% select(x) %>% distinct()
	if (nrow(o) < nrow(r))
		warning("Omitting NAs in cleanDict")
	if (nrow(d) < nrow(o))
		warning("Omitting repeated entries in cleanDict")
	if (nrow(c) < nrow(d))
		stop("Ambiguous entries found in cleanDict")
	return(d)
}

mergeDict <- function(dat, keys, values){
	return(dplyr::left_join(
		tibble(x=dat)
		, cleanDict(keys, values)
	))
}

## Fix errors if they occur
patchDict <- function(dat, dict, keys=dict[[1]], values=dict[[2]]){
	return(mergeDict(dat, keys, values)
		%>% mutate(n=ifelse(is.na(n), x, n))
		%>% pull(n)
	)
}

## Look up everything and get mad if you don't find it
catDict <- function(dat, dict, keys=dict[[1]], values=dict[[2]]){
	m <- (mergeDict(dat, keys, values))
	not_found <- filter(m, 
		!is.na(x) & is.na(n)
	)
	if (nrow(not_found) > 0){
		cat("Items not found in catDict")
		print(unique(not_found[["x"]]))
		stop("Items not found in catDict see output")
	}
	return(pull(m, n))
}
