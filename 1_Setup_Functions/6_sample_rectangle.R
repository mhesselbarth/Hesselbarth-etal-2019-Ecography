# Sample rectangular plots

sample_rectangle <- function(landscape, i, what, size, type, n) {
  
  short_edge <- 0.5 * sqrt(size) # calculate short side length
  long_edge <- 2 * sqrt(size) # calculate long side length
  
  # create sample points not nearer to landscape boundary than long side length (edge correction)
  landscape_area <- raster::extent(landscape[[i]])
  sample_area <- as(landscape_area - long_edge, 'SpatialPolygons')
  sample_points <- sp::spsample(sample_area, n = n, type = type)
  
  # create rectangle around sample points
  coords <- sp::coordinates(sample_points)
  sample_plots <- purrr::map(1:nrow(coords), function(id) { 
    
    points_corners <-
      tibble::tibble(
        x = c(
          coords[id, 1] - short_edge / 2,
          coords[id, 1] - short_edge / 2,
          coords[id, 1] + short_edge / 2,
          coords[id, 1] + short_edge / 2
        ),
        y = c(
          coords[id, 2] - long_edge / 2,
          coords[id, 2] + long_edge / 2,
          coords[id, 2] + long_edge / 2,
          coords[id, 2] - long_edge / 2
        ) 
      )
    
    current_plot <- sp::SpatialPolygons(list(sp::Polygons(list(sp::Polygon(points_corners)), ID = 1)))
    
    # rotate randomly between 0-360 degree
    maptools::elide(current_plot,
                    rotate = runif(n = 1, min = 0, max = 360),
                    center = cbind(coords[id, 1], 
                                   coords[id, 2]))
  })
  
  # clip landscape within sample plot
  sample_area <- purrr::map(seq_along(sample_plots), function(plot_id) {
    
    landscape_crop <- raster::crop(x = landscape[[i]], y = sample_plots[[plot_id]])
    landscape_mask <- raster::mask(x = landscape_crop, mask = sample_plots[[plot_id]])
    
    return(landscape_mask)
  })
    
  # calculate landscape metrics
  result <- landscapemetrics::calculate_lsm(sample_area, 
                                            what = what, 
                                            classes_max = 5,
                                            verbose = FALSE)

  return(result)
}
