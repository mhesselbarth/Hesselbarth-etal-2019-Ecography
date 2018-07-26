
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "2_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

#### 2. Create landscapes ####  

future::plan(future::multiprocess)

# Low AC
landscapes_low_ac <- simulation_run %>%
  furrr::future_map(function(seed) {
    landscape_low_autocorrelation(seed = seed)
    })

landscapes_low_ac <- stack(landscapes_low_ac)

# Medium AC
landscapes_medium_ac <- simulation_run %>%
  furrr::future_map(function(seed) {
    landscape_medium_autocorrelation(seed = seed)
  })

landscapes_medium_ac <- stack(landscapes_medium_ac)

# High AC
landscapes_high_ac <- simulation_run %>%
  furrr::future_map(function(seed) {
    landscape_high_autocorrelation(seed = seed)
  })

landscapes_high_ac <- stack(landscapes_high_ac)


#### 3. Save landscapes ####

# Low AC
UtilityFunctions::Save.Function.rds(object = landscapes_low_ac, 
                                    filename = "landscapes_low_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)

# Medium AC
UtilityFunctions::Save.Function.rds(object = landscapes_medium_ac, 
                                    filename = "landscapes_medium_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)

# High AC
UtilityFunctions::Save.Function.rds(object = landscapes_high_ac, 
                                    filename = "landscapes_high_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)
