
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

simulation_design$id <- rep(1:(nrow(simulation_design)/10), times = 10)

#### 2. Import results #### 

# Low AC
deviation_low_ac <- read_rds(paste0(getwd(), 
                                    "/3_Output/deviation_low_ac.rds"))

# Medium AC
deviation_medium_ac <- read_rds(paste0(getwd(), 
                                       "/3_Output/deviation_medium_ac.rds"))

# High AC
deviation_high_ac <- read_rds(paste0(getwd(), 
                                     "/3_Output/deviation_high_ac.rds"))

#### 3. Landscape level ####

deviation_low_ac_landscape <- dplyr::filter(deviation_medium_ac, level == "landscape") %>% 
  dplyr::left_join(unique(simulation_design[, -5]), 
                   by = c("simulation_id" = "id"), 
                   suffix = c(".dev", ".scheme"))


deviation_low_ac_landscape_sorted <- tidyr::unite(deviation_low_ac_landscape, 
                                                  unique_label, 
                                                  n.scheme, size, shape, type.scheme,
                                                  remove = FALSE) %>% 
  dplyr::arrange(type.scheme, shape, size, n.scheme) %>% 
  dplyr::mutate(correct_bins = findInterval(correct,
                                            seq(0,1, by = 0.1),
                                            rightmost.closed = TRUE))

deviation_low_ac_landscape_sorted$unique_id <- 1:nrow(deviation_low_ac_landscape_sorted)
deviation_low_ac_landscape_sorted$unique_label <- factor(deviation_low_ac_landscape_sorted$unique_label, 
                                                         levels = unique(deviation_low_ac_landscape_sorted$unique_label))


# WRONG SAMPLING SCHEMES! 
ggplot(data = deviation_low_ac_landscape_sorted, 
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
  hrbrthemes::theme_ipsum(axis_title_size = 14)

