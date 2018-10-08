# Function to sample rectangle

sample_rectangle <- function(landscape, i, what, size, type, n) {
  
  short_edge <- 0.5 * sqrt(size)
  long_edge <- 2 * sqrt(size)
  
  landscape_area <- raster::extent(landscape[[i]])
  sample_area <- as(landscape_area - long_edge, 'SpatialPolygons')
  sample_points <- sp::spsample(sample_area, n = n, type = type)
  
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
    
    maptools::elide(current_plot,
                    rotate = runif(n = 1, min = 0, max = 360),
                    center = cbind(coords[id, 1], 
                                   coords[id, 2]))
  })
  
  sample_area <- purrr::map(seq_along(sample_plots), function(plot_id) {
    
    landscape_crop <- raster::crop(x = landscape[[i]], y = sample_plots[[plot_id]])
    landscape_mask <- raster::mask(x = landscape_crop, mask = sample_plots[[plot_id]])
    
    return(landscape_mask)
  })
    
  metrics <- landscapemetrics::calculate_lsm(sample_area, 
                                             what = what, 
                                             classes_max = 5,
                                             verbose = FALSE)
  
  metrics_nested <- tidyr::nest(metrics, -layer, .key = "metrics")
  result <- dplyr::mutate(metrics_nested, sample_plot = sample_area)
  
  return(result)
}
