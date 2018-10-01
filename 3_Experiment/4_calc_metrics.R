
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

# purrr::walk(list.files(path = "2_Functions", pattern = ".R", full.names = TRUE), 
#             function(x) source(x))


#### 2. Import landscape clippings ####

# Low AC
clippings_low_ac <- purrr::map(list.files(path = "3_Experiment/0_Clippings/1_Low_AC", pattern = ".tif", full.names = TRUE), 
            function(x) raster::raster(x))

names_low_ac <- purrr::map_chr(list.files(path = "3_Experiment/0_Clippings/1_Low_AC", pattern = ".tif", full.names = FALSE), 
                               function(x) x)
names_low_ac <- stringr::str_sub(names_low_ac, start = 1, end = -5)

names(clippings_low_ac) <- names_low_ac

# Medium AC
clippings_medium_ac <- purrr::map(list.files(path = "3_Experiment/0_Clippings/2_Medium_AC", pattern = ".tif", full.names = TRUE), 
                               function(x) raster::raster(x))

names_medium_ac <- purrr::map_chr(list.files(path = "3_Experiment/0_Clippings/2_Medium_AC", pattern = ".tif", full.names = FALSE), 
                           function(x) x)
names_medium_ac <- stringr::str_sub(names_medium_ac, start = 1, end = -5)

names(clippings_medium_ac) <- names_medium_ac

# High AC
clippings_high_ac <- purrr::map(list.files(path = "3_Experiment/0_Clippings/3_High_AC", pattern = ".tif", full.names = TRUE), 
                               function(x) raster::raster(x))

names_high_ac <- purrr::map_chr(list.files(path = "3_Experiment/0_Clippings/3_High_AC", pattern = ".tif", full.names = FALSE), 
                           function(x) x)
names_high_ac <- stringr::str_sub(names_high_ac, start = 1, end = -5)

names(clippings_high_ac) <- names_high_ac

#### 3. Specify future topology ####
# 
# future_map for 1) alpha (x) 2) simulation runs (y) 3) within null model function
# login node -> { cluster nodes } -> { multiple cores }
# 
# login <- future::tweak(remote, workers = "gwdu101.gwdg.de", user = 'hesselbarth3')
# bsub <- future::tweak(future.batchtools::batchtools_lsf, template = 'lsf.tmpl',
#                       resources = list(job.name = 'association_strength',
#                                        log.file = 'association_strength.log',
#                                        queue = 'mpi-short',
#                                        walltime = '02:00',
#                                        processes = 1))
# 
# future::plan(list(login, bsub, future::sequential))
# 
# future::plan(future::multiprocess)

#### 4. Calculate metrics ####

# Low AC
# Class
class_low_ac <- furrr::future_map_dfr(seq_len(length(clippings_low_ac)), function(current_clip) { 
  
  landscapemetrics::calculate_lsm(clippings_low_ac[[current_clip]], 
                                  what = "class", verbose = FALSE)
}, .id = "clip")

class_low_ac$n_landscape <- stringr::str_split(class_low_ac$clip, 
                                               pattern = "_", 
                                               simplify = TRUE)[, 2]
class_low_ac$n_sim_design <- stringr::str_split(class_low_ac$clip, 
                                                pattern = "_", 
                                                simplify = TRUE)[, 3]
class_low_ac$n_plot <- stringr::str_split(class_low_ac$clip,
                                          pattern = "_", 
                                          simplify = TRUE)[, 4]

# Landscape
landscape_low_ac <- furrr::future_map_dfr(seq_len(length(clippings_low_ac)), function(current_clip) { 
  
  landscapemetrics::calculate_lsm(clippings_low_ac[[current_clip]], 
                              what = "landscape", verbose = FALSE)
}, .id = "clip")

landscape_low_ac$n_landscape <- stringr::str_split(landscape_low_ac$clip, 
                                               pattern = "_", 
                                               simplify = TRUE)[, 2]
landscape_low_ac$n_sim_design <- stringr::str_split(landscape_low_ac$clip, 
                                                pattern = "_", 
                                                simplify = TRUE)[, 3]
landscape_low_ac$n_plot <- stringr::str_split(landscape_low_ac$clip,
                                          pattern = "_", 
                                          simplify = TRUE)[, 4]

# Medium AC
# Class
class_medium_ac <- furrr::future_map_dfr(seq_len(length(clippings_medium_ac)), function(current_clip) { 
  
  classmetrics::calculate_lsm(clippings_medium_ac[[current_clip]], 
                              what = "class", verbose = FALSE)
}, .id = "clip")

class_medium_ac$n_landscape <- stringr::str_split(class_medium_ac$clip, 
                                               pattern = "_", 
                                               simplify = TRUE)[, 2]
class_medium_ac$n_sim_design <- stringr::str_split(class_medium_ac$clip, 
                                                pattern = "_", 
                                                simplify = TRUE)[, 3]
class_medium_ac$n_plot <- stringr::str_split(class_medium_ac$clip,
                                          pattern = "_", 
                                          simplify = TRUE)[, 4]

# Landscape
landscape_medium_ac <- furrr::future_map_dfr(seq_len(length(clippings_medium_ac)), function(current_clip) { 
  
  landscapemetrics::calculate_lsm(clippings_medium_ac[[current_clip]], 
                                  what = "landscape", verbose = FALSE)
}, .id = "clip")

landscape_medium_ac$n_landscape <- stringr::str_split(landscape_medium_ac$clip, 
                                                   pattern = "_", 
                                                   simplify = TRUE)[, 2]
landscape_medium_ac$n_sim_design <- stringr::str_split(landscape_medium_ac$clip, 
                                                    pattern = "_", 
                                                    simplify = TRUE)[, 3]
landscape_medium_ac$n_plot <- stringr::str_split(landscape_medium_ac$clip,
                                              pattern = "_", 
                                              simplify = TRUE)[, 4]

# High AC
# Class
class_high_ac <- furrr::future_map_dfr(seq_len(length(clippings_high_ac)), function(current_clip) { 
  
  classmetrics::calculate_lsm(clippings_high_ac[[current_clip]], 
                              what = "class", verbose = FALSE)
}, .id = "clip")

class_high_ac$n_landscape <- stringr::str_split(class_high_ac$clip, 
                                               pattern = "_", 
                                               simplify = TRUE)[, 2]
class_high_ac$n_sim_design <- stringr::str_split(class_high_ac$clip, 
                                                pattern = "_", 
                                                simplify = TRUE)[, 3]
class_high_ac$n_plot <- stringr::str_split(class_high_ac$clip,
                                          pattern = "_", 
                                          simplify = TRUE)[, 4]

# Landscape
landscape_high_ac <- furrr::future_map_dfr(seq_len(length(clippings_high_ac)), function(current_clip) { 
  
  landscapemetrics::calculate_lsm(clippings_high_ac[[current_clip]], 
                                  what = "landscape", verbose = FALSE)
}, .id = "clip")

landscape_high_ac$n_landscape <- stringr::str_split(landscape_high_ac$clip, 
                                                   pattern = "_", 
                                                   simplify = TRUE)[, 2]
landscape_high_ac$n_sim_design <- stringr::str_split(landscape_high_ac$clip, 
                                                    pattern = "_", 
                                                    simplify = TRUE)[, 3]
landscape_high_ac$n_plot <- stringr::str_split(landscape_high_ac$clip,
                                              pattern = "_", 
                                              simplify = TRUE)[, 4]

#### 4. Save results ####

overwrite <- FALSE

# Low AC
UtilityFunctions::Save.Function.rds(object = class_low_ac,
                                    filename = "class_low_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = overwrite)

UtilityFunctions::Save.Function.rds(object = landscape_low_ac,
                                    filename = "landscape_low_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = overwrite)

# Medium AC
UtilityFunctions::Save.Function.rds(object = class_medium_ac,
                                    filename = "class_medium_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = overwrite)

UtilityFunctions::Save.Function.rds(object = landscape_medium_ac,
                                    filename = "landscape_medium_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = overwrite)

# High AC
UtilityFunctions::Save.Function.rds(object = class_high_ac,
                                    filename = "class_high_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)

UtilityFunctions::Save.Function.rds(object = landscape_high_ac,
                                    filename = "landscape_high_ac.rds",
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)
