
# 1. Source functions 
purrr::walk(list.files(path = "1_Setup", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "2_Simulate_NLM", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "3_Sampling_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))


# 2. Calculate "true" values
simulation_run <- seq(5, 10, 5) #seq(5,50, 5)

future::plan(future::multiprocess)

true_value_low_ac <- simulation_run %>%
  furrr::future_map_dfr(function(seed) {
    
    landscape_low_autocorrelation(seed = seed) %>%
      landscapemetrics::lsm_l_lpi()
    
  }, .id = "simulation_run") %>%
  dplyr::mutate(simulation_run = as.integer(simulation_run))

# 2. Import results 

results_low_ac <- readr::read_rds(path = paste0(getwd(), 
                                                "/4_Results/results_low_ac.rds"))

# results_medium_ac <- readr::read_rds(path = paste0(getwd(),
#                                                    "/4_Results/results_medium_ac.rds"))
# 
# results_high_ac <- readr::read_rds(path = paste0(getwd(),
#                                                  "/4_Results/results_high_ac.rds"))

estimate_landscape_value(data = results_low_ac)

