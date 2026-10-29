## Okabe-Ito colour-blind-safe palette as the default for base and ggplot
## discrete scales (viridis for continuous); load with shellpipes::sourceFiles()

okabe <- palette.colors(palette = "Okabe-Ito")[-1]   # drop black

palette(okabe)                                        # base graphics
options(
	ggplot2.discrete.colour   = okabe,                 # ggplot discrete
	ggplot2.discrete.fill     = okabe,
	ggplot2.continuous.colour = "viridis",             # ggplot continuous
	ggplot2.continuous.fill   = "viridis"
)
