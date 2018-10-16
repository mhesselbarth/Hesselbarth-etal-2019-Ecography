
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

simulation_design$id <- rep(1:(nrow(simulation_design) / 50), times = 50)

overwrite <- FALSE

#### 2. Import results #### 

# Low AC
deviation_low_ac <- read_rds(paste0(getwd(), 
                                    "/3_Output/deviation_low_ac_50.rds"))

deviation_low_ac$autocorrelation <- "low"

# Medium AC
deviation_medium_ac <- read_rds(paste0(getwd(), 
                                       "/3_Output/deviation_medium_ac_50.rds"))

deviation_medium_ac$autocorrelation <- "medium"

# High AC
deviation_high_ac <- read_rds(paste0(getwd(), 
                                     "/3_Output/deviation_high_ac_50.rds"))

deviation_high_ac$autocorrelation <- "high"

#### 3. Summarised by metrics ####
deviation_complete_ac <- dplyr::bind_rows(deviation_low_ac, deviation_medium_ac, deviation_high_ac)
deviation_complete_ac$autocorrelation <- factor(deviation_complete_ac$autocorrelation, levels=c('low','medium','high'))

deviation_joined <- dplyr::filter(deviation_complete_ac, level == "landscape") %>% 
  dplyr::left_join(unique(simulation_design[, -5]), 
                   by = c("simulation_id" = "id"), 
                   suffix = c(".lsm", ".scheme"))

deviation_joined <- dplyr::mutate(deviation_joined, 
                                  percentage = dplyr::case_when(size ==  2500 & n.scheme == 10 ~ 10,
                                                                size ==  2500 & n.scheme == 35 ~ 35,
                                                                size ==  2500 & n.scheme == 75 ~ 75,
                                                                size ==  7500 & n.scheme == 4 ~ 10,
                                                                size ==  7500 & n.scheme == 12 ~ 35,
                                                                size ==  7500 & n.scheme == 25 ~ 75, 
                                                                size == 20000 & n.scheme == 2 ~ 10,
                                                                size == 20000 & n.scheme == 5 ~ 35,
                                                                size == 20000 & n.scheme == 10 ~ 75))

deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type.scheme, level, class, metric) %>%
  dplyr::summarise(correct = mean(inside_ci, na.rm = TRUE), 
                   false = 1 - correct, 
                   deviation_rel = mean(deviation_rel, na.rm = TRUE))  %>% 
  dplyr::mutate(correct_bins = findInterval(correct,
                                            seq(0, 1, by = 0.1),
                                            rightmost.closed = TRUE))

deviation_summarised <- dplyr::left_join(deviation_summarised, 
                                         landscapemetrics::lsm_abbreviations_names, 
                                         by = "metric")

results_landscape <- dplyr::filter(deviation_summarised, level == "landscape") %>%
  tidyr::unite(unique_label,
               percentage, shape, type.scheme,
               remove = FALSE) %>% 
  dplyr::arrange(type.scheme, shape, percentage)

results_landscape$unique_label <- factor(results_landscape$unique_label, 
                                         levels = unique(results_landscape$unique_label))

ggplot_metrics <-  ggplot(data = results_landscape, 
                          aes(x = metric, y = unique_label)) +
  geom_tile(aes(fill = factor(correct_bins))) + 
  facet_wrap(~ autocorrelation + type, 
             scales = "free_x", 
             ncol = 6, nrow = 3) +
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
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) #+ 
  # theme_ipsum(axis_title_size = 14)

UtilityFunctions::save_ggplot(ggplot_metrics, 
                              filename = "ggplot_metrics.png", 
                              path = paste0(getwd(), "/4_Plots"), 
                              overwrite = overwrite, 
                              width = 50, height = 25, units = "cm")

#### 4. Summarised by type ####
deviation_complete_ac <- dplyr::bind_rows(deviation_low_ac, deviation_medium_ac, deviation_high_ac)
deviation_complete_ac$autocorrelation <- factor(deviation_complete_ac$autocorrelation, levels=c('low','medium','high'))

deviation_joined <- dplyr::filter(deviation_complete_ac, level == "landscape") %>% 
  dplyr::left_join(unique(simulation_design[, -5]), 
                   by = c("simulation_id" = "id"), 
                   suffix = c(".lsm", ".scheme"))

deviation_joined <- dplyr::mutate(deviation_joined, 
                                  percentage = dplyr::case_when(size ==  2500 & n.scheme == 10 ~ 10,
                                                                size ==  2500 & n.scheme == 35 ~ 35,
                                                                size ==  2500 & n.scheme == 75 ~ 75,
                                                                size ==  7500 & n.scheme == 4 ~ 10,
                                                                size ==  7500 & n.scheme == 12 ~ 35,
                                                                size ==  7500 & n.scheme == 25 ~ 75, 
                                                                size == 20000 & n.scheme == 2 ~ 10,
                                                                size == 20000 & n.scheme == 5 ~ 35,
                                                                size == 20000 & n.scheme == 10 ~ 75))

deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type.scheme, level, class, type.lsm) %>%
  dplyr::summarise(correct = mean(inside_ci, na.rm = TRUE), 
                   false = 1 - correct, 
                   deviation_rel = mean(deviation_rel, na.rm = TRUE))  %>% 
  dplyr::mutate(correct_bins = findInterval(correct,
                                            seq(0, 1, by = 0.1),
                                            rightmost.closed = TRUE))

results_landscape <- dplyr::filter(deviation_summarised, level == "landscape") %>%
  tidyr::unite(unique_label,
               percentage, shape, type.scheme,
               remove = FALSE) %>% 
  dplyr::arrange(type.scheme, shape, percentage)

results_landscape$unique_label <- factor(results_landscape$unique_label, 
                                         levels = unique(results_landscape$unique_label))

ggplot_type <- ggplot(data = results_landscape, 
       aes(x = type.lsm,
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
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) #+ 
  # theme_ipsum(axis_title_size = 14)

UtilityFunctions::save_ggplot(ggplot_type, 
                              filename = "ggplot_type.png", 
                              path = paste0(getwd(), "/4_Plots"), 
                              overwrite = overwrite, 
                              width = 50, height = 25, units = "cm")


#### 5. Hypotheses ####
deviation_complete_ac <- dplyr::bind_rows(deviation_low_ac, deviation_medium_ac, deviation_high_ac)
deviation_complete_ac$autocorrelation <- factor(deviation_complete_ac$autocorrelation, levels=c('low','medium','high'))

deviation_joined <- dplyr::filter(deviation_complete_ac, level == "landscape") %>% 
  dplyr::left_join(unique(simulation_design[, -5]), 
                   by = c("simulation_id" = "id"), 
                   suffix = c(".lsm", ".scheme"))

deviation_joined <- dplyr::mutate(deviation_joined, 
                                  percentage = dplyr::case_when(size ==  2500 & n.scheme == 10 ~ 10,
                                                                size ==  2500 & n.scheme == 35 ~ 35,
                                                                size ==  2500 & n.scheme == 75 ~ 75,
                                                                size ==  7500 & n.scheme == 4 ~ 10,
                                                                size ==  7500 & n.scheme == 12 ~ 35,
                                                                size ==  7500 & n.scheme == 25 ~ 75, 
                                                                size == 20000 & n.scheme == 2 ~ 10,
                                                                size == 20000 & n.scheme == 5 ~ 35,
                                                                size == 20000 & n.scheme == 10 ~ 75))

deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, size, n.scheme, shape, type.scheme, level, class, type.lsm) %>%
  dplyr::summarise(nn = n(),
    correct = mean(inside_ci, na.rm = TRUE), 
                   false = 1 - correct, 
                   deviation_rel = mean(deviation_rel, na.rm = TRUE))  %>% 
  dplyr::mutate(correct_bins = findInterval(correct,
                                            seq(0, 1, by = 0.1),
                                            rightmost.closed = TRUE))

results_landscape <- dplyr::filter(deviation_summarised, level == "landscape") %>%
  tidyr::unite(unique_label,
               size, n.scheme, shape, type.scheme,
               remove = FALSE) %>% 
  dplyr::arrange(type.scheme, shape, size, n.scheme,)

results_landscape$unique_label <- factor(results_landscape$unique_label, 
                                         levels = unique(results_landscape$unique_label))

# Hypothesis 1
results_landscape %>% 
  dplyr::group_by(size, n.scheme, autocorrelation, type.lsm) %>%
  dplyr::summarise(correct = mean(correct), 
                   false = mean(false)) %>% 
  dplyr::arrange(autocorrelation, type.lsm, size, n.scheme)

hypothesis_1 <- aov(results_landscape$correct ~ as.factor(results_landscape$percentage))
summary(hypothesis_1)
TukeyHSD(hypothesis_1)

# Hypothesis 2
results_landscape %>% 
  dplyr::group_by(shape, autocorrelation, type.lsm) %>% 
  dplyr::summarise(n = n(), 
                   correct = mean(correct), 
                   false = mean(false)) %>% 
  dplyr::arrange(autocorrelation, type.lsm, shape)

hypothesis_2 <- aov(results_landscape$correct ~ as.factor(results_landscape$shape))
summary(hypothesis_2)
TukeyHSD(hypothesis_2)

# Hypothesis 3
results_landscape %>% 
  dplyr::group_by(type.scheme, autocorrelation, type.lsm) %>% 
  dplyr::summarise(n = n(), 
                   correct = mean(correct), 
                   false = mean(false)) %>% 
  dplyr::arrange(autocorrelation, type.lsm,  type.scheme)

random <- dplyr::filter(results_landscape, type.scheme == "random") %>% dplyr::pull(correct)
regular <- dplyr::filter(results_landscape, type.scheme == "regular") %>% dplyr::pull(correct)

t.test(random, regular)

