sample_plots <- function(landscape, what, shape, size, type, n, alpha = 1.96,
                         n_sim_design, n_landscape, path){
  
  # print(paste0("Starting shape=", shape))
  
  if(shape == "circle"){
    results <- sample_circles(landscape = landscape, what = what, 
                              size = size, type = type, n = n, alpha = alpha,
                              n_sim_design = n_sim_design, 
                              n_landscape = n_landscape, 
                              path = path)
    # gc()
    return(results)
  }
  
  else if (shape == "square"){
    results <- sample_squares(landscape = landscape, what = what,
                              size = size, type = type, n = n, alpha = alpha,
                              n_sim_design = n_sim_design, 
                              n_landscape = n_landscape,
                              path = path)
    # gc()
    return(results)
  }
  
  else if(shape == "rectangle"){
    results <-  sample_rectangle(landscape = landscape, what = what, 
                                 size = size, type = type, n = n, alpha = alpha,
                                 n_sim_design = n_sim_design, 
                                 n_landscape = n_landscape,
                                 path = path)
    # gc()
    return(results)
  }
  
  else{warning("Please select either 'circle', 'square' or 'shape' as shape", 
               call. = FALSE)}
  
}
