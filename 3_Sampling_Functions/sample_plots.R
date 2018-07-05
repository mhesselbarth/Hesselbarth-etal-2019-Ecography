sample_plots <- function(landscape, shape, size, type, n , metrics = TRUE){
  
  if(shape == "circle"){
    sample_circles(landscape = landscape, size = size, type = type, n = n, metrics = TRUE)
  }
  
  else if (shape == "square"){
    sample_squares(landscape = landscape, size = size, type = type, n = n, metrics = TRUE)
  }
  
  else if(shape == "rectangle"){
    sample_rectangle(landscape = landscape, size = size, type = type, n = n, metrics = TRUE)
  }
  
  else{warning("Please select either 'circle', 'square' or 'shape' as shape", 
               call. = FALSE)}
  
}
