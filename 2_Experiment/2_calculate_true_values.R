
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

#### 2. Import landscapes #### 

# Low AC
landscapes_low_ac <- readr::read_rds(paste0(getwd(), 
                                            "/3_Output/landscapes_low_ac.rds"))

# Medium AC
landscapes_medium_ac <- readr::read_rds(paste0(getwd(), 
                                               "/3_Output/landscapes_medium_ac.rds"))

# High AC
landscapes_high_ac <- readr::read_rds(paste0(getwd(), 
                                             "/3_Output/landscapes_high_ac.rds"))


#### 3. Calculate "real" values ####

# Low AC
true_value_low_ac <- clustermq::Q(fun = calculate_lsm_helper,
                                  i = seq_along(landscapes_low_ac), 
                                  const = list(landscape = landscapes_low_ac,
                                               what = "all",
                                               classes_max = 5,  
                                               verbose = FALSE),
                                  n_jobs = 10, 
                                  template = list(queue = "mpi", 
                                                  walltime = "06:00", 
                                                  processes = 1))

# Medium AC
true_value_medium_ac <- clustermq::Q(fun = calculate_lsm_helper,
                                     i = seq_along(landscapes_medium_ac), 
                                     const = list(landscape = landscapes_low_ac,
                                                  what = "all",
                                                  classes_max = 5,  
                                                  verbose = FALSE),
                                     n_jobs = 10, 
                                     template = list(queue = "mpi", 
                                                     walltime = "06:00", 
                                                     processes = 1))

# High AC
true_value_high_ac <- clustermq::Q(fun = calculate_lsm_helper,
                                   i = seq_along(landscapes_high_ac), 
                                   const = list(landscape = landscapes_low_ac,
                                                what = "all",
                                                classes_max = 5,  
                                                verbose = FALSE),
                                   n_jobs = 10, 
                                   template = list(queue = "mpi", 
                                                   walltime = "06:00", 
                                                   processes = 1))


#### 4. Save results ####

overwrite <- FALSE

# Low AC
UtilityFunctions::save_rds(object = true_value_low_ac,
                           filename = "true_value_low_ac.rds", 
                           path = paste0(getwd(), "/3_Output"), 
                           overwrite = overwrite)

# Medium AC
UtilityFunctions::save_rds(object = true_value_medium_ac,
                           filename = "true_value_medium_ac.rds", 
                           path = paste0(getwd(), "/3_Output"), 
                           overwrite = overwrite)

# High AC
UtilityFunctions::save_rds(object = true_value_high_ac,
                           filename = "true_value_high_ac.rds", 
                           path = paste0(getwd(), "/3_Output"), 
                           overwrite = overwrite)
