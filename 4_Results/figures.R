# plot landscapes
ls_high <- landscape_high_autocorrelation(10)
ls_medium <- landscape_medium_autocorrelation(10)
ls_low <- landscape_low_autocorrelation(10)


size <- c(100, 1250, 7500)
n <- c(10, 25, 50)
shape <- c("circle", "square", "rectangle")
type <- c("random", "regular")

simulation_design <- expand.grid(size = size, 
                                 n = n, 
                                 shape = shape, 
                                 type = type) %>%
  tibble::as.tibble()

plots <- furrr::future_map(seq_len(nrow(simulation_design)), function(row_simdesign) {
  sample_plots(landscape = ls_low_autocor,
               shape = simulation_design$shape[row_simdesign],
               size = simulation_design$size[row_simdesign],
               type = simulation_design$type[row_simdesign],
               n    = simulation_design$n[row_simdesign],
               metrics = FALSE)
})

util_facetplot(list("a) Low Autocorrelation and Quadrat Sampling"    = ls_low,
                    "b) Medium Autocorrelation and Rectangle Sampling" = ls_medium,
                    "c) High Autocorrelation and Circle Sampling"   = ls_high))
