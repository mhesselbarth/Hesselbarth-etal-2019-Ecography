sample_plots <- function(landscape, shape, size, type, n){
  
  if(shape == "circle"){
    results <- sample_circles(landscape = landscape, size = size, type = type, n = n)
    # gc()
    return(results)
  }
  
  else if (shape == "square"){
    results <- sample_squares(landscape = landscape, size = size, type = type, n = n)
    # gc()
    return(results)
  }
  
  else if(shape == "rectangle"){
    results <-  sample_rectangle(landscape = landscape, size = size, type = type, n = n)
    # gc()
    return(results)
  }
  
  else{warning("Please select either 'circle', 'square' or 'shape' as shape", 
               call. = FALSE)}
  
}
