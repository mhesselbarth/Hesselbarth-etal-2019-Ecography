#### 1. Load libraries and source functions #### 
library(ggplot2)
library(gridExtra)
library(helpeR) # devtools::install_github("mhesselbarth/helpeR")
library(landscapemetrics)
library(tidyverse)
library(raster)

# size of final plot
width <- 16.6
height <- width * 0.25
dpi <- 300
overwrite <- TRUE

# plot whole landscape
ggplot_landscape <- raster::as.data.frame(landscape, xy = TRUE) %>% 
  dplyr::mutate(what = "") %>% 
  ggplot2::ggplot(ggplot2::aes(x, y)) +
  ggplot2::geom_raster(ggplot2::aes(fill = factor(clumps))) +
  ggplot2::facet_wrap(~ what) +
  ggplot2::scale_x_continuous(expand = c(0, 0)) +
  ggplot2::scale_y_continuous(expand = c(0, 0)) +
  ggplot2::coord_fixed() +
  ggplot2::scale_fill_manual(values = c("#009392", "#f1eac8","#d0587e")) +
  ggplot2::guides(fill = FALSE) +
  ggplot2::labs(titel = NULL, x = NULL, y = NULL) +
  ggplot2::theme(
    axis.title  = ggplot2::element_blank(),
    axis.ticks  = ggplot2::element_blank(),
    axis.text   = ggplot2::element_blank(),
    panel.grid  = ggplot2::element_blank(),
    axis.line   = ggplot2::element_blank(),
    strip.background = ggplot2::element_rect(fill = "grey80"),
    strip.text = ggplot2::element_text(hjust  = 0),
    panel.background = ggplot2::element_rect(fill = "grey85"),
    plot.margin = ggplot2::unit(c(0, 0, 0, 0), "lines"))

# plot patches
ggplot_patches <- landscapemetrics::show_patches(landscape, class = 1, 
                                                 labels = FALSE)

# plot cores
ggplot_cores <- landscapemetrics::show_cores(landscape, class = 1, 
                                             labels = FALSE)

# add to one plot
ggplot_overall <- gridExtra::grid.arrange(ggplot_landscape, 
                                          ggplot_patches, 
                                          ggplot_cores,
                                          nrow = 1, ncol = 3, 
                                          widths = c(width, width, width), 
                                          heights = height)

# save results
helpeR::save_ggplot(plot = ggplot_overall, 
                    path = "4_Plots", 
                    filename = "ggplot_overall.pdf", 
                    width = width, dpi = dpi, height = height, units = "cm",
                    overwrite = overwrite)

helpeR::save_ggplot(plot = ggplot_overall, 
                    path = "4_Plots", 
                    filename = "ggplot_overall.jpeg", 
                    width = width, height = height, dpi = dpi, units = "cm",
                    overwrite = overwrite)

helpeR::save_ggplot(plot = ggplot_overall, 
                    path = "4_Plots", 
                    filename = "ggplot_overall.eps", 
                    width = width, height = height, dpi = dpi, units = "cm",
                    overwrite = overwrite)
