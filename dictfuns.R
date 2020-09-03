patchDict <- function(dat, dict, keys=dict[[1]], values=dict[[2]]){
	fill <- dplyr::left_join(
		tibble(x=dat)
		, tibble(x=keys, n=values)
	)

	return(fill 
		%>% mutate(x=ifelse(is.na(n), x, n))
		%>% pull(x)
	)
}
