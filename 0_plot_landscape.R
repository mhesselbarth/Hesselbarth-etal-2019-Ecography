#### 1. Load libraries and source functions #### 
library(cowplot)
library(ggplot2)
library(helpeR) # devtools::install_github("mhesselbarth/helpeR")
library(landscapemetrics)
library(magrittr)
library(tidyverse)
library(raster)

size <- 10.5

# plot whole landscape
ggplot_landscape <- raster::as.data.frame(landscape, xy = TRUE) %>% 
  dplyr::mutate(what = "a) Landscape") %>% 
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
    text = ggplot2::element_text(size = size),
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
ggplot_patches <- landscapemetrics::get_patches(landscape, class = 1) %>%
  magrittr::extract2(1) %>% 
  raster::as.data.frame(xy = TRUE) %>% 
  dplyr::mutate(what = "b) Patches") %>%
  ggplot2::ggplot(ggplot2::aes(x, y)) +
  ggplot2::coord_fixed() +
  ggplot2::geom_raster(ggplot2::aes(fill = layer)) +
  ggplot2::scale_fill_gradientn(
    colours = c(
      "#5F4690",
      "#1D6996",
      "#38A6A5",
      "#0F8554",
      "#73AF48",
      "#EDAD08",
      "#E17C05",
      "#CC503E",
      "#94346E",
      "#6F4070",
      "#994E95"
    ),
    na.value = "grey85"
  ) +
  ggplot2::facet_wrap(~ what) +
  ggplot2::scale_x_continuous(expand = c(0, 0)) +
  ggplot2::scale_y_continuous(expand = c(0, 0)) +
  ggplot2::guides(fill = FALSE) +
  ggplot2::labs(titel = NULL, x = NULL, y = NULL) +
  ggplot2::theme(
    text = ggplot2::element_text(size = size),
    axis.title  = ggplot2::element_blank(),
    axis.ticks  = ggplot2::element_blank(),
    axis.text   = ggplot2::element_blank(),
    panel.grid  = ggplot2::element_blank(),
    axis.line   = ggplot2::element_blank(),
    strip.background = ggplot2::element_rect(fill = "grey80"),
    strip.text = ggplot2::element_text(hjust  = 0),
    plot.margin = ggplot2::unit(c(0, 0, 0, 0), "lines"))

# plot cores
ggplot_cores <- landscapemetrics::get_patches(landscape, class = 1) %>%
  magrittr::extract2(1) %>% 
  landscapemetrics::get_boundaries() %>%  
  raster::as.data.frame(xy = TRUE) %>% 
  dplyr::mutate(what = "c) Core areas") %>% 
  ggplot2::ggplot(ggplot2::aes(x, y)) +
  ggplot2::coord_fixed() +
  ggplot2::geom_raster(ggplot2::aes(fill = as.factor(layer))) +
  ggplot2::scale_fill_manual(values = c("#E17C05", "grey60"),
                             na.value = "grey85") +
  ggplot2::facet_wrap(~ what) +
  ggplot2::scale_x_continuous(expand = c(0, 0)) +
  ggplot2::scale_y_continuous(expand = c(0, 0)) +
  ggplot2::guides(fill = FALSE) +
  ggplot2::labs(titel = NULL, x = NULL, y = NULL) +
  ggplot2::theme(
    text = ggplot2::element_text(size = size),
    axis.title  = ggplot2::element_blank(),
    axis.ticks  = ggplot2::element_blank(),
    axis.text   = ggplot2::element_blank(),
    panel.grid  = ggplot2::element_blank(),
    axis.line   = ggplot2::element_blank(),
    strip.background = ggplot2::element_rect(fill = "grey80"),
    strip.text = ggplot2::element_text(hjust  = 0),
    plot.margin = ggplot2::unit(c(0, 0, 0, 0), "lines"))
  

# add to one plot
ggplot_overall <- cowplot::plot_grid(ggplot_landscape, ggplot_patches, ggplot_cores, 
                                     nrow = 1, ncol = 3)

# save results
# size of final plot
width <- 16.6
height <- width * 0.4
dpi <- 300
overwrite <- FALSE

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
