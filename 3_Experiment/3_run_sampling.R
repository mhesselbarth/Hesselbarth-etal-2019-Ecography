
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


#### 3. Run sampling ####

options(rasterMaxMemory = 1e10)

# future::plan(list(future::sequential, future::multiprocess))
# future::plan(sequential)

# Low AC
walk(seq_len(nlayers(landscapes_low_ac)), function(current_landscape) {
  walk(seq_len(nrow(simulation_design)), function(current_design) {

    sample_plots(
      landscape = landscapes_low_ac[[current_landscape]],
      what = "class",
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]], 
      n_sim_design = current_design, 
      n_landscape = current_landscape,
      path = "/3_Experiment/0_Clippings/1_Low_AC/"
    )
  })
})

# Medium AC
walk(seq_len(nlayers(landscapes_low_ac)), function(current_landscape) {
  walk(seq_len(nrow(simulation_design)), function(current_design) {
    
    sample_plots(
      landscape = landscapes_medium_ac[[current_landscape]],
      what = "class",
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]], 
      n_sim_design = current_design, 
      n_landscape = current_landscape,
      path = "/3_Experiment/0_Clippings/2_Medium_AC/"
    )
  })
})

# High AC
walk(seq_len(nlayers(landscapes_low_ac)), function(current_landscape) {
  walk(seq_len(nrow(simulation_design)), function(current_design) {

    sample_plots(
      landscape = landscapes_high_ac[[current_landscape]],
      what = "class",
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]], 
      n_sim_design = current_design, 
      n_landscape = current_landscape,
      path = "/3_Experiment/0_Clippings/3_High_AC/"
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


