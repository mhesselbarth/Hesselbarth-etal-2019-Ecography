# Function to sample circles

sample_circles <- function(landscape, what, size, type, n) {
  
  size <- sqrt(size / pi)
  
  landscape_area <- raster::extent(landscape)
  sample_area <- as(landscape_area - size, 'SpatialPolygons')
  sample_points <- sp::spsample(sample_area, n = n, type = type)
  
  sample_plots <- construct_buffer(points = sample_points, 
                                   shape = "circle", size = size)
  
  result <- purrr::map_dfr(seq_along(sample_plots), function(plot_id) {
    
    landscape_crop <- raster::crop(x = landscape, y = sample_plots[plot_id])
    landscape_mask <- raster::mask(x = landscape_crop, mask = sample_plots[plot_id])
    
    results <- landscapemetrics::calculate_lsm(landscape_mask, 
                                               what = what, verbose = FALSE)},
    .id = "sample_plot")
  
  return(result)
}
