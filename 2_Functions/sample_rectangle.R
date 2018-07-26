# Function to sample rectangle

sample_rectangle <-
  function(landscape, size, type, n, metrics = TRUE) {
    
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
    
    sample_plots <- purrr::map(seq_len(nrow(coords)), function(id) {
      
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
      
      sample_plot <- points_corners %>%
        sp::Polygon() %>%
        list() %>%
        sp::Polygons(ID = 1) %>%
        list() %>%
        sp::SpatialPolygons()
      
      sample_plot <- maptools::elide(sample_plot,
                                      rotate = runif(n = 1, min = 0, max = 360),
                                      center = cbind(coords[id, 1], 
                                                     coords[id, 2]))
    })
    
    if (metrics == TRUE) {
      sample_plots <- purrr::map_dfr(sample_plots, function(current_plot) {
        landscape_crop <- raster::crop(x = landscape, y = current_plot)
        landscape_mask <- raster::mask(x = landscape_crop, mask = current_plot)
        calculate_metrics(landscape_mask, what = "lsm_c_dcad") # needs to be c("class", "landscape)
        }, .id = "plot")
    }
    
    return(sample_plots)
  }
