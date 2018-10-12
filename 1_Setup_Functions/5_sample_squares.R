# Function to sample squares

sample_squares <- function(landscape, i, what, size, type, n) {
  
  size <- sqrt(size)
  
  landscape_area <- raster::extent(landscape[[i]])
  sample_area <- as(landscape_area - size, 'SpatialPolygons')
  sample_points <- sp::spsample(sample_area, n = n, type = type)
  
  sample_plots <- landscapemetrics::construct_buffer(points = sample_points, 
                                                     shape = "square", size = size)
  
  sample_area <- purrr::map(seq_along(sample_plots), function(plot_id) {
    
    landscape_crop <- raster::crop(x = landscape[[i]], y = sample_plots[plot_id])
    landscape_mask <- raster::mask(x = landscape_crop, mask = sample_plots[plot_id])
    
    return(landscape_mask)
  })
  
  result <- landscapemetrics::calculate_lsm(sample_area,
                                            what = what, 
                                            classes_max = 5,
                                            verbose = FALSE)
  
  # metrics_nested <- tidyr::nest(metrics, -layer, .key = "metrics")
  # result <- dplyr::mutate(metrics_nested, sample_plot = sample_area)
  
  return(result)
}
