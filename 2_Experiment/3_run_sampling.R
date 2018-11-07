#### 1. Load libraries and source functions #### 
library(clustermq)
library(landscapemetrics)
library(maptools)
library(purrr)
library(raster)
library(readr)
library(sp)

purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

overwrite <- FALSE # dont overwrite if file already exists

#### 2. Low AC #### 

landscapes_low_ac <- readr::read_rds(paste0(getwd(), 
                                     "/3_Output/landscapes_low_ac_50.rds"))

sampling_low_ac <- clustermq::Q_rows(fun = sample_plots,
                                     df = simulation_design,
                                     const = list(landscape = landscapes_low_ac, 
                                                  what = c("class", "landscape")), 
                                     export = list(sample_circles = sample_circles, 
                                                   sample_squares = sample_squares, 
                                                   sample_rectangle = sample_rectangle),
                                     n_jobs = 1500, 
                                     seed = 42,
                                     template = list(queue = "mpi", 
                                                     walltime = "48:00", 
                                                     processes = 1))

UtilityFunctions::save_rds(object = sampling_low_ac,
                           filename = "sampling_low_ac_50.rds",
                           path = paste0(getwd(), "/3_Output"),
                           overwrite = overwrite)

# rm(landscapes_low_ac)

#### 3. Medium AC ####
landscapes_medium_ac <- readr::read_rds(paste0(getwd(), 
                                        "/3_Output/landscapes_medium_ac_50.rds"))

sampling_medium_ac <- clustermq::Q_rows(fun = sample_plots,
                                        df = simulation_design,
                                        const = list(landscape = landscapes_medium_ac, 
                                                     what = c("class", "landscape")), 
                                        export = list(sample_circles = sample_circles, 
                                                      sample_squares = sample_squares, 
                                                      sample_rectangle = sample_rectangle),
                                        n_jobs = 1500, 
                                        seed = 42,
                                        template = list(queue = "mpi", 
                                                        walltime = "48:00", 
                                                        processes = 1))

UtilityFunctions::save_rds(object = sampling_medium_ac,
                           filename = "sampling_medium_ac_50.rds",
                           path = paste0(getwd(), "/3_Output"),
                           overwrite = overwrite)

# rm(landscapes_medium_ac)

#### 4. High AC ####
landscapes_high_ac <- readr::read_rds(paste0(getwd(), 
                                      "/3_Output/landscapes_high_ac_50.rds"))

sampling_high_ac <- clustermq::Q_rows(fun = sample_plots,
                                      df = simulation_design,
                                      const = list(landscape = landscapes_high_ac, 
                                                   what = c("class", "landscape")), 
                                      export = list(sample_circles = sample_circles, 
                                                    sample_squares = sample_squares, 
                                                    sample_rectangle = sample_rectangle),
                                      n_jobs = 1500, 
                                      seed = 42,
                                      template = list(queue = "mpi", 
                                                      walltime = "48:00", 
                                                      processes = 1))

UtilityFunctions::save_rds(object = sampling_high_ac,
                           filename = "sampling_high_ac_50.rds",
                           path = paste0(getwd(), "/3_Output"),
                           overwrite = overwrite)

# rm(landscapes_high_ac)

