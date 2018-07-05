set.seed(42)

#### 1. source simulation function ####

purrr::walk(list.files(path = "1_Setup", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "2_Simulate_NLM", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "3_Sampling_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

#### 2. Create simulation design ####

size <- c(100, 1250, 7500)
n <- c(10, 25, 50)
shape <- c("circle", "square", "rectangle")
type <- c("random", "regular")

simulation_design <- expand.grid(size = size, 
                          n = n, 
                          shape = shape, 
                          type = type) %>%
  tibble::as.tibble()

simulation_run <- seq(5, 10, 5) #seq(5,50, 5)

#### 3. Run simulations ####

future::plan(list(future::sequential, future::multiprocess))

results_low_ac <- simulation_run %>%
  furrr::future_map_dfr(function(seed) {
    ls_low_autocor <- landscape_low_autocorrelation(seed = seed)
    
    furrr::future_map_dfr(seq_len(nrow(simulation_design)), function(row_simdesign) {
      sample_plots(landscape = ls_low_autocor,
                   shape = simulation_design$shape[row_simdesign],
                   size = simulation_design$size[row_simdesign],
                   type = simulation_design$type[row_simdesign],
                   n    = simulation_design$n[row_simdesign])
  }, .id = "simulation_design")
}, .id = "simulation_run") %>%
  dplyr::mutate(simulation_design = as.integer(simulation_design),
                simulation_run = as.integer(simulation_run))

results_medium_ac <- simulation_run %>%
  furrr::future_map_dfr(function(seed) {
    ls_low_autocor <- landscape_medium_autocorrelation(seed = seed)
    
    furrr::future_map_dfr(seq_len(nrow(simulation_design)), function(row_simdesign) {
      sample_plots(landscape = ls_low_autocor,
                   shape = simulation_design$shape[row_simdesign],
                   size = simulation_design$size[row_simdesign],
                   type = simulation_design$type[row_simdesign],
                   n    = simulation_design$n[row_simdesign])
    }, .id = "simulation_design")
  }, .id = "simulation_run") %>%
  dplyr::mutate(simulation_design = as.integer(simulation_design),
                simulation_run = as.integer(simulation_run))

results_high_ac <- simulation_run %>%
  furrr::future_map_dfr(function(seed) {
    ls_low_autocor <- landscape_high_autocorrelation(seed = seed)
    
    furrr::future_map_dfr(seq_len(nrow(simulation_design)), function(row_simdesign) {
      sample_plots(landscape = ls_low_autocor,
                   shape = simulation_design$shape[row_simdesign],
                   size = simulation_design$size[row_simdesign],
                   type = simulation_design$type[row_simdesign],
                   n    = simulation_design$n[row_simdesign])
    }, .id = "simulation_design")
  }, .id = "simulation_run") %>%
  dplyr::mutate(simulation_design = as.integer(simulation_design),
                simulation_run = as.integer(simulation_run))


#### 4. Save Results ####
UtilityFunctions::Save.Function.rds(object = results_low_ac, 
                                    filename = "results_low_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"), 
                                    overwrite = FALSE)

UtilityFunctions::Save.Function.rds(object = results_medium_ac, 
                                    filename = "results_medium_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)

UtilityFunctions::Save.Function.rds(object = results_low_ac, 
                                    filename = "results_high_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)


