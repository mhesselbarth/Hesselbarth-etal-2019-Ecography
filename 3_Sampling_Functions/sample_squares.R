# Function to sample circles

sample_squares <- function(landscape, size, type, n){
  
  width = sqrt(size) / 2

  if(type == "random"){
    
    sample_plots <- landscape %>%
      raster::extent() %>%
      magrittr::subtract(., width * 2) %>% 
      as('SpatialPolygons') %>%
      sp::spsample(n = n, type = type) %>%
      rgeos::gBuffer(width = width, byid = TRUE, quadsegs = 1, capStyle="SQUARE") # size needs to be converted to area
  }
  
  else if(type == "regular"){
    
    sample_plots <- landscape %>%
      raster::extent() %>%
      magrittr::subtract(., width * 2) %>% 
      as('SpatialPolygons') %>%
      sp::spsample(n = n, type = type) %>%
      rgeos::gBuffer(width = width, byid = TRUE, quadsegs = 1, capStyle="SQUARE") # size needs to be converted to area
  }
  
  else{stop("Please select type == 'random' or type == 'regular", call. = FALSE)}
  
  result <- sample_plots %>%
    seq_along() %>% 
    purrr::map_dfr(function(plot_id){
      landscape_crop <- raster::crop(x = landscape, y = sample_plots[plot_id,])
      landscape_mask <- raster::mask(x = landscape_crop, mask = sample_plots[plot_id,])
      value <- lsm_l_lpi(landscape_mask) # needs to be lsm_calculate()
    }, .id = "plot")
  
  return(result)
}