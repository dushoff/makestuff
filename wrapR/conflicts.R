
## Over-ride base stuff silently (see “mask”). Make user resolve other conflicts
options(
	conflicts.policy = list(
		error = TRUE, warn = FALSE, generics.ok = TRUE
		, can.mask = c("base", "methods", "utils"
			, "grDevices", "graphics", "stats"
		)
		, depends.ok = TRUE
	)
	, tidyverse.quiet = TRUE
)
