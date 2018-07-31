# Function to sample circles

sample_squares <-
  function(landscape, size, type, n) {
   
    width = sqrt(size) / 2
    
    if (type == "random") {
      sample_points <- landscape %>%
        raster::extent() %>%
        magrittr::subtract(., width * 2) %>%
        as('SpatialPolygons') %>%
        sp::spsample(n = n, type = type) %>%
        rgeos::gBuffer(
          width = width,
          byid = TRUE,
          quadsegs = 1,
          capStyle = "SQUARE"
        ) # size needs to be converted to area
    }
    
    else if (type == "regular") {
      sample_points <- landscape %>%
        raster::extent() %>%
        magrittr::subtract(., width * 2) %>%
        as('SpatialPolygons') %>%
        sp::spsample(n = n, type = type) %>%
        rgeos::gBuffer(
          width = width,
          byid = TRUE,
          quadsegs = 1,
          capStyle = "SQUARE"
        ) # size needs to be converted to area
    }
    
    else{
      stop("Please select type == 'random' or type == 'regular", call. = FALSE)
    }
    
    sample_plots <- purrr::map_dfr(seq_along(sample_points), function(plot_id) {
      landscape_crop <- raster::crop(x = landscape, y = sample_points[plot_id])
      landscape_mask <- raster::mask(x = landscape_crop, mask = sample_points[plot_id])
      
      results <- calculate_metrics(landscape_mask, what = "class")}, 
      .id = "sample_plot")
    
    gc()

    return(sample_plots)
  }
