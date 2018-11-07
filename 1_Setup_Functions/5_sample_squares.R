# Sample squared plots

sample_squares <- function(landscape, i, what, size, type, n) {
  
  size <- sqrt(size) # calculate side length 
  
  # create sample points not nearer to landscape boundary than side length (edge correction)
  landscape_area <- raster::extent(landscape[[i]])
  sample_area <- as(landscape_area - size, 'SpatialPolygons')
  sample_points <- sp::spsample(sample_area, n = n, type = type)
  
  # create square around sample points
  sample_plots <- landscapemetrics::construct_buffer(points = sample_points, 
                                                     shape = "square", size = size)
  
  # clip landscape within sample plots
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
