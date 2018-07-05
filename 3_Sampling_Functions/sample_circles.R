# Function to sample circles

sample_circles <- function(landscape, size, type, n, metrics = TRUE){
  
  width = sqrt(size / pi)
  
  if(type == "random"){
    
    sample_plots <- landscape %>%
      raster::extent() %>%
      magrittr::subtract(., width * 2) %>% 
      as('SpatialPolygons') %>%
      sp::spsample(n = n, type = type) %>%
      rgeos::gBuffer(width = width, byid = TRUE) # size needs to be converted to area
    }
  
  else if(type == "regular"){
    
    sample_plots <- landscape %>%
      raster::extent() %>%
      magrittr::subtract(., width*2) %>% 
      as('SpatialPolygons') %>%
      sp::spsample(n = n, type = type) %>%
      rgeos::gBuffer(width = width, byid = TRUE) # size needs to be converted to area
  }
  
  else{stop("Please select type == 'random' or type == 'regular", call. = FALSE)}
  
  if(metrics == TRUE){
    sample_plots <- sample_plots %>%
    seq_along() %>% 
    purrr::map_dfr(function(plot_id){
      landscape_crop <- raster::crop(x = landscape, y = sample_plots[plot_id,])
      landscape_mask <- raster::mask(x = landscape_crop, mask = sample_plots[plot_id,])
      value <- lsm_l_lpi(landscape_mask) # needs to be lsm_calculate()
    }, .id = "plot")
  }
  return(sample_plots)
}
