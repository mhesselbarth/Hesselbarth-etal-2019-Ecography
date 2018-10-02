
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

#### 3. Run sampling ####

# Low AC
sampling_low_ac <- clustermq::Q(fun = sample_plots,
                                landscape = rep(landscapes_low_ac, each = nrow(simulation_design)),
                                shape = as.character(simulation_design$shape), 
                                type = as.character(simulation_design$type),
                                n = simulation_design$n, 
                                const = list(what = c("class", "landscape")), 
                                export = list(sample_circles = sample_circles, 
                                              sample_squares = sample_squares, 
                                              sample_rectangle = sample_rectangle),
                                n_jobs = 540, 
                                template = list(queue = "mpi-short", 
                                                walltime = "01:00", 
                                                processes = 1))

# Medium AC
sampling_medium_ac <- clustermq::Q(fun = sample_plots,
                                landscape = rep(landscapes_medium_ac, each = nrow(simulation_design)),
                                shape = as.character(simulation_design$shape), 
                                type = as.character(simulation_design$type),
                                n = simulation_design$n, 
                                const = list(what = c("class", "landscape")), 
                                export = list(sample_circles = sample_circles, 
                                              sample_squares = sample_squares, 
                                              sample_rectangle = sample_rectangle),
                                n_jobs = 540, 
                                template = list(queue = "mpi-short", 
                                                walltime = "01:00", 
                                                processes = 1))

# High AC
sampling_high_ac <- clustermq::Q(fun = sample_plots,
                                landscape = rep(landscapes_high_ac, each = nrow(simulation_design)),
                                shape = as.character(simulation_design$shape), 
                                type = as.character(simulation_design$type),
                                n = simulation_design$n, 
                                const = list(what = c("class", "landscape")), 
                                export = list(sample_circles = sample_circles, 
                                              sample_squares = sample_squares, 
                                              sample_rectangle = sample_rectangle),
                                n_jobs = 540, 
                                template = list(queue = "mpi-short", 
                                                walltime = "01:00", 
                                                processes = 1))


#### 4. Save Results ####

overwrite <- FALSE

UtilityFunctions::Save.Function.rds(object = sampling_low_ac,
                                    filename = "sampling_low_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = overwrite)

UtilityFunctions::Save.Function.rds(object = sampling_medium_ac,
                                    filename = "sampling_medium_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = overwrite)

UtilityFunctions::Save.Function.rds(object = sampling_high_ac,
                                    filename = "sampling_high_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = overwrite)


