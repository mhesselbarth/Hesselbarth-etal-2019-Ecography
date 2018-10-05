
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

#### 2. Import landscapes #### 

# Low AC
landscapes_low_ac <- read_rds(paste0(getwd(), 
                                     "/3_Output/landscapes_low_ac.rds"))

# Medium AC
landscapes_medium_ac <- read_rds(paste0(getwd(), 
                                        "/3_Output/landscapes_medium_ac.rds"))

# High AC
landscapes_high_ac <- read_rds(paste0(getwd(), 
                                      "/3_Output/landscapes_high_ac.rds"))


#### 3. Calculate "real" values ####


# Low AC
true_value_low_ac <- clustermq::Q(fun = landscapemetrics::calculate_lsm,
                                  landscape = landscapes_low_ac,
                                  const = list(what = c("class", "landscape"),
                                               directions = 8, 
                                               count_boundary = FALSE, 
                                               consider_boundary = FALSE,
                                               edge_depth = 1, 
                                               classes_max = NULL, 
                                               neighbourhood = 4,
                                               ordered = TRUE, 
                                               base = "log2", 
                                               full_name = FALSE, 
                                               verbose = FALSE,
                                               progress = FALSE), 
                                  n_jobs = 10, 
                                  template = list(queue = "mpi-short", 
                                                  walltime = "02:00", 
                                                  processes = 1, 
                                                  log_file = "debug.log"))

# Medium AC
true_value_medium_ac <- clustermq::Q(fun = landscapemetrics::calculate_lsm,
                                     landscape = landscapes_medium_ac,
                                     const = list(what = c("class", "landscape"),
                                                  directions = 8, 
                                                  count_boundary = FALSE, 
                                                  consider_boundary = FALSE,
                                                  edge_depth = 1, 
                                                  classes_max = NULL, 
                                                  neighbourhood = 4,
                                                  ordered = TRUE, 
                                                  base = "log2", 
                                                  full_name = FALSE, 
                                                  verbose = FALSE,
                                                  progress = FALSE),
                                     n_jobs = 10, 
                                     template = list(queue = "mpi-short", 
                                                     walltime = "02:00", 
                                                     processes = 1, 
                                                     log_file = "debug.log"))

# High AC
true_value_high_ac <- clustermq::Q(fun = landscapemetrics::calculate_lsm,
                                   landscape = landscapes_high_ac,
                                   const = list(what = c("class", "landscape"),
                                                directions = 8, 
                                                count_boundary = FALSE, 
                                                consider_boundary = FALSE,
                                                edge_depth = 1, 
                                                classes_max = NULL, 
                                                neighbourhood = 4,
                                                ordered = TRUE, 
                                                base = "log2", 
                                                full_name = FALSE, 
                                                verbose = FALSE,
                                                progress = FALSE),
                                   n_jobs = 10, 
                                   template = list(queue = "mpi-short", 
                                                   walltime = "02:00", 
                                                   processes = 1, 
                                                   log_file = "debug.log"))


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
