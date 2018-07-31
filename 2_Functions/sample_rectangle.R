# Function to sample rectangle

sample_rectangle <-
  function(landscape, size, type, n) {
    
    short_edge <- 0.5 * sqrt(size)
    long_edge <- 2 * sqrt(size)
    
    if (type == "random") {
      sample_points <- landscape %>%
        raster::extent() %>%
        magrittr::subtract(., long_edge * 2) %>%
        as('SpatialPolygons') %>%
        sp::spsample(n = n, type = type)
    }
    
    else if (type == "regular") {
      sample_points <- landscape %>%
        raster::extent() %>%
        magrittr::subtract(., long_edge * 2) %>%
        as('SpatialPolygons') %>%
        sp::spsample(n = n, type = type)
    }
    
    else{
      stop("Please select type == 'random' or type == 'regular", call. = FALSE)
    }
    
    coords <- sp::coordinates(sample_points)
    
    sample_points <- purrr::map(seq_len(nrow(coords)), function(id) {
      
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
      
      current_plot <- points_corners %>%
        sp::Polygon() %>%
        list() %>%
        sp::Polygons(ID = 1) %>%
        list() %>%
        sp::SpatialPolygons()
      
      current_plot <- maptools::elide(current_plot,
                                      rotate = runif(n = 1, min = 0, max = 360),
                                      center = cbind(coords[id, 1], 
                                                     coords[id, 2]))
    })
    
    sampled_landscape_metrics <- purrr::map_dfr(seq_along(sample_points), function(plot_id) {
      landscape_crop <- raster::crop(x = landscape, y = sample_points[plot_id])
      landscape_mask <- raster::mask(x = landscape_crop, mask = sample_points[plot_id])
      
      results <- calculate_metrics(landscape_mask, what = "class")}, 
      .id = "sample_plot")
    
    gc()

    return(sampled_landscape_metrics)
  }
