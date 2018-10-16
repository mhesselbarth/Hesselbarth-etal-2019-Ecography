
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

overwrite <- FALSE

#### 2. Low AC ####
landscapes_low_ac <- readr::read_rds(paste0(getwd(), 
                                            "/3_Output/landscapes_low_ac_50.rds"))

true_value_low_ac <- clustermq::Q(fun = calculate_lsm_helper,
                                  i = seq_along(landscapes_low_ac), 
                                  const = list(landscape = landscapes_low_ac,
                                               what =  c("class", "landscape")),
                                  n_jobs = length(landscapes_low_ac), 
                                  template = list(queue = "mpi", 
                                                  walltime = "06:00", 
                                                  processes = 1))

UtilityFunctions::save_rds(object = true_value_low_ac,
                           filename = "true_value_low_ac_50.rds", 
                           path = paste0(getwd(), "/3_Output"), 
                           overwrite = overwrite)

# rm(landscapes_low_ac)

#### 3. Medium AC ####
landscapes_medium_ac <- readr::read_rds(paste0(getwd(), 
                                               "/3_Output/landscapes_medium_ac_50.rds"))

true_value_medium_ac <- clustermq::Q(fun = calculate_lsm_helper,
                                     i = seq_along(landscapes_medium_ac), 
                                     const = list(landscape = landscapes_medium_ac,
                                                  what = c("class", "landscape")),
                                     n_jobs = length(landscapes_medium_ac), 
                                     template = list(queue = "mpi", 
                                                     walltime = "06:00", 
                                                     processes = 1))

UtilityFunctions::save_rds(object = true_value_medium_ac,
                           filename = "true_value_medium_ac_50.rds", 
                           path = paste0(getwd(), "/3_Output"), 
                           overwrite = overwrite)

# rm(landscapes_medium_ac)

#### 4. High AC ####
landscapes_high_ac <- readr::read_rds(paste0(getwd(), 
                                             "/3_Output/landscapes_high_ac_50.rds"))

true_value_high_ac <- clustermq::Q(fun = calculate_lsm_helper,
                                   i = seq_along(landscapes_high_ac), 
                                   const = list(landscape = landscapes_high_ac,
                                                what = c("class", "landscape")),
                                   n_jobs = length(landscapes_high_ac), 
                                   template = list(queue = "mpi", 
                                                   walltime = "06:00", 
                                                   processes = 1))

UtilityFunctions::save_rds(object = true_value_high_ac,
                           filename = "true_value_high_ac_50.rds", 
                           path = paste0(getwd(), "/3_Output"), 
                           overwrite = overwrite)

# rm(landscapes_high_ac)

