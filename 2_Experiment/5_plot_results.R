
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

simulation_design$id <- rep(1:(nrow(simulation_design)/25), times = 25)

#### 2. Import results #### 

# Low AC
deviation_low_ac <- read_rds(paste0(getwd(), 
                                    "/3_Output/deviation_low_ac_25.rds"))

deviation_low_ac$autocorrelation <- "low"

# Medium AC
deviation_medium_ac <- read_rds(paste0(getwd(), 
                                       "/3_Output/deviation_medium_ac_25.rds"))

deviation_medium_ac$autocorrelation <- "medium"

# High AC
deviation_high_ac <- read_rds(paste0(getwd(), 
                                     "/3_Output/deviation_high_ac_25.rds"))

deviation_high_ac$autocorrelation <- "high"


#### 3. Plot results ####

#
all_ac <- dplyr::bind_rows(deviation_low_ac, deviation_medium_ac, deviation_high_ac)
all_ac$autocorrelation <- factor(all_ac$autocorrelation, levels=c('low','medium','high'))

results_joined <- dplyr::filter(all_ac, level == "landscape") %>% 
  dplyr::left_join(unique(simulation_design[, -5]), 
                   by = c("simulation_id" = "id"), 
                   suffix = c(".dev", ".scheme")) %>% 
  dplyr::mutate(percentage = dplyr::case_when(size == 2500 & n.scheme == 10 ~ 10,
                                              size == 2500 & n.scheme == 35 ~ 35,
                                              size == 2500 & n.scheme == 75 ~ 75,
                                              size == 7500 & n.scheme == 4 ~ 10,
                                              size == 7500 & n.scheme == 12 ~ 35,
                                              size == 7500 & n.scheme == 25 ~ 75, 
                                              size == 20000 & n.scheme == 2 ~ 10,
                                              size == 20000 & n.scheme == 5 ~ 35,
                                              size == 20000 & n.scheme == 10 ~ 75))

results_sorted <- tidyr::unite(results_joined, 
                               unique_label, 
                               percentage, size, shape, type.scheme,
                               remove = FALSE) %>% 
  dplyr::arrange(type.scheme, shape, size, n.scheme) %>% 
  dplyr::mutate(correct_bins = findInterval(correct,
                                            seq(0, 1, by = 0.1),
                                            rightmost.closed = TRUE))

results_sorted$unique_id <- 1:nrow(results_sorted)
results_sorted$unique_label <- factor(results_sorted$unique_label, 
                                      levels = unique(results_sorted$unique_label))

ggplot(data = results_sorted, 
       aes(x = type.dev,
           y = unique_label)) +
  geom_tile(aes(fill = factor(correct_bins))) + 
  facet_wrap( ~ autocorrelation) +
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
                      " < 100")) + 
  labs(x = "Landscape metrics", y = "Sample scheme") + 
  theme_ipsum(axis_title_size = 14)
W