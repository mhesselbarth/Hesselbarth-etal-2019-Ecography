
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "2_Simulate_NLM", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "3_Sampling_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))


#### 2. Calculate "true" values #### 
simulation_run <- seq(5, 10, 5) #seq(5,50, 5)

future::plan(future::multiprocess)

# Low AC
true_value_low_ac <- simulation_run %>%
  furrr::future_map_dfr(function(seed) {
    
    landscape_low_autocorrelation(seed = seed) %>%
      landscapemetrics::lsm_l_lpi()
    
  }, .id = "simulation_run") %>%
  dplyr::mutate(simulation_run = as.integer(simulation_run))

# Medium AC
true_value_medium_ac <- simulation_run %>%
  furrr::future_map_dfr(function(seed) {
    
    landscape_medium_autocorrelation(seed = seed) %>%
      landscapemetrics::lsm_l_lpi()
    
  }, .id = "simulation_run") %>%
  dplyr::mutate(simulation_run = as.integer(simulation_run))

# High AC
true_value_high_ac <- simulation_run %>%
  furrr::future_map_dfr(function(seed) {
    
    landscape_high_autocorrelation(seed = seed) %>%
      landscapemetrics::lsm_l_lpi()
    
  }, .id = "simulation_run") %>%
  dplyr::mutate(simulation_run = as.integer(simulation_run))

#### 3. Import results ####  
results_low_ac <- readr::read_rds(path = paste0(getwd(), 
                                                "/4_Results/results_low_ac.rds"))

# results_medium_ac <- readr::read_rds(path = paste0(getwd(),
#                                                    "/4_Results/results_medium_ac.rds"))
# 
# results_high_ac <- readr::read_rds(path = paste0(getwd(),
#                                                  "/4_Results/results_high_ac.rds"))

#### 4. Calculate percentage of correct results #### 
# Low AC
percentage_low_ac <- results_low_ac %>%
  estimate_landscape_value() %>%
  dplyr::left_join(true_value_low_ac, 
                   by = c("simulation_run", "metric")) %>% 
  dplyr::mutate(within_ci = dplyr::case_when(value > lo & value < hi ~ 1, 
                                             value < lo ~ 0, 
                                             value > hi ~ 0)) %>%
  dplyr::group_by(simulation_design) %>%
  dplyr::summarise(n = (sum(within_ci) / n()) * 100)

# # Medium AC
# percentage_medium_ac <- results_medium_ac %>%
#   estimate_landscape_value() %>%
#   dplyr::left_join(true_value_medium_ac,
#                    by = c("simulation_run", "metric")) %>%
#   dplyr::mutate(within_ci = dplyr::case_when(value > lo & value < hi ~ 1,
#                                              value < lo ~ 0,
#                                              value > hi ~ 0)) %>%
#   dplyr::group_by(simulation_design) %>%
#   dplyr::summarise(n = (sum(within_ci) / n()) * 100)
# 
# # High AC
# percentage_high_ac <- results_high_ac %>%
#   estimate_landscape_value() %>%
#   dplyr::left_join(true_value_high_ac,
#                    by = c("simulation_run", "metric")) %>%
#   dplyr::mutate(within_ci = dplyr::case_when(value > lo & value < hi ~ 1,
#                                              value < lo ~ 0,
#                                              value > hi ~ 0)) %>%
#   dplyr::group_by(simulation_design) %>%
#   dplyr::summarise(n = (sum(within_ci) / n()) * 100)