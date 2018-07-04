library(NLMR)
library(raster)
library(rgeos)
library(sp)
library(tidyverse)
library(landscapemetrics)

# Function to sample circles

sample_circles <- function(landscape, size, type, n){
  if(type == "random"){
    
    sample_plots <- landscape %>%
      raster::extent() %>%
      as('SpatialPolygons') %>%
      sp::spsample(n = n, type = type) %>%
      rgeos::gBuffer(width = size, byid = TRUE) # size needs to be converted to area
    }
  
  else if(type == "regular"){
    
    sample_plots <- landscape %>%
      raster::extent() %>%
      as('SpatialPolygons') %>%
      sp::spsample(n = n, type = type) %>%
      rgeos::gBuffer(width = size, byid = TRUE) # size needs to be converted to area
  }
  
  else{warning("Please select type == 'random' or type == 'regular", call. = FALSE)}
  
  result <- sample_plots %>%
    seq_along() %>% 
    purrr::map_dfr(function(plot_id){
      landscape_crop <- raster::crop(x = landscape, y = sample_plots[plot_id,])
      landscape_mask <- raster::mask(x = landscape_crop, mask = sample_plots[plot_id,])
      value <- lsm_l_ta(landscape_mask) # needs to be lsm_calculate()
    }, .id = "plot")
  
  return(result)
}