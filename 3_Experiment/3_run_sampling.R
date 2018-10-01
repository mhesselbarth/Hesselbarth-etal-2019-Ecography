
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "2_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

#### 2. Import landscapes #### 

# Low AC
landscapes_low_ac <- read_rds(paste0(getwd(), 
                                     "/4_Results/landscapes_low_ac.rds"))

# Medium AC
landscapes_medium_ac <- read_rds(paste0(getwd(), 
                                        "/4_Results/landscapes_medium_ac.rds"))

# High AC
landscapes_high_ac <- read_rds(paste0(getwd(), 
                                      "/4_Results/landscapes_high_ac.rds"))


#### 3. Specify future topology ####
# 
# future_map for 1) alpha (x) 2) simulation runs (y) 3) within null model function
# login node -> { cluster nodes } -> { multiple cores }
# 
login <- future::tweak(remote, workers = "gwdu101.gwdg.de", user = 'hesselbarth3')
bsub <- future::tweak(future.batchtools::batchtools_lsf, template = 'lsf.tmpl',
                      resources = list(job.name = 'sample_lsm',
                                       log.file = 'sample_lsm.log',
                                       queue = 'mpi-short',
                                       walltime = '02:00',
                                       processes = 1))

future::plan(list(login, bsub, future::sequential))

# future::plan(future::multiprocess)

#### 4. Run sampling ####

# Low AC
sampling_low_ac <- furrr::future_map(1:3, function(current_landscape) {
  furrr::future_map(1:5, function(current_design) {

    sample_plots(
      landscape = landscapes_low_ac[[current_landscape]],
      what = c("class", "landscape"),
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]]
    )
  })
})

# Medium AC
sampling_medium_ac <- purrr::map(1:length(landscapes_medium_ac), function(current_landscape) {
  purrr::map(1:nrow(simulation_design), function(current_design) {
    
    sample_plots(
      landscape = landscapes_medium_ac[[current_landscape]],
      what = c("class", "landscape"),
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]]
    )
  })
})

# High AC
sampling_high_ac <- purrr::map(1:length(landscapes_high_ac), function(current_landscape) {
  purrr::map(1:nrow(simulation_design), function(current_design) {

    sample_plots(
      landscape = landscapes_high_ac[[current_landscape]],
      what = c("class", "landscape"),
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]]
    )
  })
})

#### 4. Save Results ####
# UtilityFunctions::Save.Function.rds(object = sampling_low_ac, 
#                                     filename = "sampling_low_ac.rds", 
#                                     path = paste0(getwd(), "/4_Results"), 
#                                     overwrite = TRUE)
# 
# UtilityFunctions::Save.Function.rds(object = sampling_medium_ac, 
#                                     filename = "sampling_medium_ac.rds", 
#                                     path = paste0(getwd(), "/4_Results"),
#                                     overwrite = TRUE)
# 
# UtilityFunctions::Save.Function.rds(object = sampling_high_ac, 
#                                     filename = "sampling_high_ac.rds", 
#                                     path = paste0(getwd(), "/4_Results"),
#                                     overwrite = TRUE)


