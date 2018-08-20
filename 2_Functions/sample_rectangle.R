# Function to sample rectangle

sample_rectangle <- function(landscape, what, size, type, n, alpha = 1.96,
                             n_sim_design, n_landscape, path) {
    
    # print(paste0("Starting: size=", size, " // type=", type, " // n=", n))
    print(paste0("Starting Clip_", n_landscape, "_", n_sim_design, ".tif"))
  
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
    
    # sample_points <- purrr::map(seq_len(nrow(coords)), function(id) {
    #   
    #   points_corners <-
    #     tibble::tibble(
    #       x = c(
    #         coords[id, 1] - short_edge / 2,
    #         coords[id, 1] - short_edge / 2,
    #         coords[id, 1] + short_edge / 2,
    #         coords[id, 1] + short_edge / 2
    #       ),
    #       y = c(
    #         coords[id, 2] - long_edge / 2,
    #         coords[id, 2] + long_edge / 2,
    #         coords[id, 2] + long_edge / 2,
    #         coords[id, 2] - long_edge / 2
    #       ) 
    #     )
    #   
    #   current_plot <- points_corners %>%
    #     sp::Polygon() %>%
    #     list() %>%
    #     sp::Polygons(ID = 1) %>%
    #     list() %>%
    #     sp::SpatialPolygons()
    #   
    #   current_plot <- maptools::elide(current_plot,
    #                                   rotate = runif(n = 1, min = 0, max = 360),
    #                                   center = cbind(coords[id, 1], 
    #                                                  coords[id, 2]))
    # })
    
    sample_points <- list()
    
    for(id in 1:nrow(coords)) {
      
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
      
      sample_points <- c(sample_points, current_plot)
    }
    
    # sampled_landscape_metrics <- purrr::map_dfr(seq_along(sample_points), function(plot_id) {
    #   
    #   landscape_crop <- raster::crop(x = landscape, y = sample_points[[plot_id]])
    #   landscape_mask <- raster::mask(x = landscape_crop, mask = sample_points[[plot_id]])
    #   
    #   results <- calculate_metrics(landscape_mask, what = c("lsm_c_ed", "lsm_c_pland"))}, 
    #   .id = "sample_plot")
    
    sampled_landscape_metrics <- tibble::tibble()
    
    for(plot_id in 1:length(sample_points)){
      
      landscape_crop <- raster::crop(x = landscape, y = sample_points[[plot_id]])
      landscape_mask <- raster::mask(x = landscape_crop, mask = sample_points[[plot_id]])
      
      raster::writeRaster(landscape_mask, filename = paste0(getwd(), path, "Clip_", 
                                                            n_landscape, "_",
                                                            n_sim_design, "_", 
                                                            plot_id, 
                                                            ".tif"))
      
      # results <- calculate_metrics(landscape_mask, what = what, verbose = FALSE)
      # 
      # sampled_landscape_metrics <- dplyr::bind_rows(sampled_landscape_metrics, results)
    }
    
    # sampled_landscape_metrics <- dplyr::group_by(sampled_landscape_metrics, class, metric)
    # 
    # estimation <- dplyr::summarise(sampled_landscape_metrics, 
    #                                n = n(), 
    #                                mean = mean(value),
    #                                sd = sd(value), 
    #                                ci = alpha *  (sd / sqrt(n)),
    #                                lo = mean - ci, 
    #                                hi = mean + ci)
    # 
    # dplyr::ungroup(estimation)
    # 
    # estimation <- estimation[complete.cases(estimation), ]
    
    print("Done!")
    cat("\n\n")
    
    # return(estimation)
  }
