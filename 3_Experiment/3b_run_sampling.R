
sampling_low_ac <- tibble::tibble()

for(current_landscape in 1:nlayers(landscapes_low_ac)) {
  for (current_design in 1:nrow(simulation_design)) {
    
    current_result <- sample_plots(
      landscape = landscapes_low_ac[[current_landscape]],
      shape = simulation_design$shape[[current_design]],
      size = simulation_design$size[[current_design]],
      type = simulation_design$type[[current_design]],
      n    = simulation_design$n[[current_design]]
    )
    
    current_result$simulation_run <- current_landscape 
    current_result$simulation_design <- current_design 
    
    sampling_low_ac <- dplyr::bind_rows(sampling_low_ac, current_result)
    
    cat(paste0("\rCurrent landscape: ", current_landscape, " \\ ", 
                 "Current design: ", current_design, " \\ done! "))
    
  }
}


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