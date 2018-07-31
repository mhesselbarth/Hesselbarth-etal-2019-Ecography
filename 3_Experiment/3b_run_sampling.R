
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

# Low AC
sampling_low_ac <- list()

for(current_landscape in 1:nlayers(landscapes_low_ac)) {
  
  list_current_design <- list()
  
  for (current_design in 1:nrow(simulation_design)) {
    
    current_result <- sample_plots(
      landscape = landscapes_low_ac[[current_landscape]],
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]]
    )
    
    list_current_design <- c(list_current_design, list(current_result))
    
    cat(paste0("\rCurrent landscape: ", current_landscape, " \\ ", 
                 "Current design: ", current_design, " \\ done! "))
  }
  
  sampling_low_ac <- c(sampling_low_ac, list(list_current_design))
}

# Medium AC
sampling_medium_ac <- tibble::tibble()

for(current_landscape in 1:nlayers(landscapes_medium_ac)) {
  for (current_design in 1:nrow(simulation_design)) {
    
    current_result <- sample_plots(
      landscape = landscapes_medium_ac[[current_landscape]],
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]]
    )
    
    current_result$simulation_run <- current_landscape 
    current_result$simulation_design <- current_design 
    
    sampling_medium_ac <- dplyr::bind_rows(sampling_medium_ac, current_result)
    
    cat(paste0("\rCurrent landscape: ", current_landscape, " \\ ", 
                 "Current design: ", current_design, " \\ done! "))
    
  }
}

# High AC
sampling_high_ac <- tibble::tibble()

for(current_landscape in 1:nlayers(landscapes_high_ac)) {
  for (current_design in 1:nrow(simulation_design)) {
    
    current_result <- sample_plots(
      landscape = landscapes_high_ac[[current_landscape]],
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]]
    )
    
    current_result$simulation_run <- current_landscape 
    current_result$simulation_design <- current_design 
    
    sampling_high_ac <- dplyr::bind_rows(sampling_high_ac, current_result)
    
    cat(paste0("\rCurrent landscape: ", current_landscape, " \\ ", 
                 "Current design: ", current_design, " \\ done! "))
    
  }
}