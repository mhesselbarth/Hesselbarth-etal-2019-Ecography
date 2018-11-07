# Sample circle plots

sample_circles <- function(landscape, i, what, size, type, n) {
  
  size <- sqrt(size / pi) # calculate radius
  
  # create sample points not nearer to landscape boundary than radius (edge correction)
  landscape_area <- raster::extent(landscape[[i]])
  sample_area <- as(landscape_area - size, 'SpatialPolygons')
  sample_points <- sp::spsample(sample_area, n = n, type = type)
  
  # create circle around sample points
  sample_plots <- landscapemetrics::construct_buffer(points = sample_points, 
                                                     shape = "circle", size = size)
  
  # clip values within plot
  sample_area <- purrr::map(seq_along(sample_plots), function(plot_id) {
    
    landscape_crop <- raster::crop(x = landscape[[i]], y = sample_plots[plot_id])
    landscape_mask <- raster::mask(x = landscape_crop, mask = sample_plots[plot_id])
    
    return(landscape_mask)
  })
  
  # calculate landscape metrics
  result <- landscapemetrics::calculate_lsm(sample_area, 
                                            what = what, 
                                            classes_max = 5,
                                            verbose = FALSE)
  
  return(result)
}
