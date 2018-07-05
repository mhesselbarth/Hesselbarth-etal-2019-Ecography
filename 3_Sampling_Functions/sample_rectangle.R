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
    
    coords <- sp::coordinates(sample_points[plot_id])
    
    points_corners <-
      tibble::tibble(
        x = c(
          coords[1] - short_edge / 2,
          coords[1] - short_edge / 2,
          coords[1] + short_edge / 2,
          coords[1] + short_edge / 2
        ),
        y = c(
          coords[2] - long_edge / 2,
          coords[2] + long_edge / 2,
          coords[2] + long_edge / 2,
          coords[2] - long_edge / 2
        )
      )
    
    sample_plots <- points_corners %>%
      sp::Polygon() %>%
      list() %>%
      sp::Polygons(ID = 1) %>%
      list() %>%
      sp::SpatialPolygons()
    
    sample_plots <- maptools::elide(sample_plot,
                                   rotate = runif(n = 1, min = 0, max = 360),
                                   center = coords)
    
    
    if (metrics == TRUE) {
      sample_plots <- sample_plots %>%
        seq_along() %>%
        purrr::map_dfr(function(plot_id) {
          landscape_crop <-
            raster::crop(x = landscape, y = sample_plots[plot_id, ])
          landscape_mask <-
            raster::mask(x = landscape_crop, mask = sample_plots[plot_id, ])
          value <-
            lsm_l_lpi(landscape_mask) # needs to be lsm_calculate()
        }, .id = "plot")
    }
    
    return(sample_plots)
  }
