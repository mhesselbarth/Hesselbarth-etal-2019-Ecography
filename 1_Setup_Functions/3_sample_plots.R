sample_plots <- function(landscape, i, what, shape, size, type, n){
  
  if(shape == "circle"){
    results <- sample_circles(landscape = landscape, i = i, 
                              what = what, 
                              size = size, type = type, n = n)
    
    return(results)
  }
  
  else if (shape == "square"){
    results <- sample_squares(landscape = landscape, i = i, 
                              what = what,
                              size = size, type = type, n = n)
    
    return(results)
  }
  
  else if(shape == "rectangle"){
    results <-  sample_rectangle(landscape = landscape, i = i, 
                                 what = what, 
                                 size = size, type = type, n = n)
    
    return(results)
  }
  
  else{warning("Please select either 'circle', 'square' or 'shape' as shape", 
               call. = FALSE)}
}
