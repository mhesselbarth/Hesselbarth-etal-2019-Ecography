#### Functions to plot results ####



# Heatmap of every sampling scheme for the 6 groups of LSM (Fig. x in the manuscript)

plot_heatmap <- function(results, simulation_design){
  
  results_joined <- dplyr::filter(results, level == "landscape") %>% 
    dplyr::left_join(unique(simulation_design[, -5]), 
                     by = c("simulation_id" = "id"), 
                     suffix = c(".dev", ".scheme"))
  
  
  results_sorted <- tidyr::unite(results_joined, 
                                                    unique_label, 
                                                    n.scheme, size, shape, type.scheme,
                                                    remove = FALSE) %>% 
    dplyr::arrange(type.scheme, shape, size, n.scheme) %>% 
    dplyr::mutate(correct_bins = findInterval(correct,
                                              seq(0,1, by = 0.1),
                                              rightmost.closed = TRUE))
  
  results_sorted$unique_id <- 1:nrow(results_sorted)
  results_sorted$unique_label <- factor(results_sorted$unique_label, 
                                        levels = unique(results_sorted$unique_label))

  ggplot(data = results_sorted, 
         aes(x = type.dev,
             y = unique_label)) +
    geom_tile(aes(fill = factor(correct_bins))) + 
    scale_fill_brewer(name = "% Correct \nestimation",
                      type = "div",
                      palette = "Spectral",
                      labels = c(
                        " < 10",
                        " < 20",
                        " < 30",
                        " < 40",
                        " < 50",
                        " < 60",
                        " < 70",
                        " < 80",
                        " < 90",
                        " < 100"
                      )) + 
    labs(x = "Landscape metrics", y = "Sample scheme") + 
    theme_ipsum(axis_title_size = 14)
  
  
}

