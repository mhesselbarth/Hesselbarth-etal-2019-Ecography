
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
                   suffix = c("_deviation", "_scheme")) %>% 
  dplyr::left_join(landscapemetrics::lsm_abbreviations_names, 
                   by = "metric", 
                   suffix = c("_scheme", "_lsm"))

deviation_joined <- dplyr::mutate(deviation_joined, 
                                  percentage = dplyr::case_when(size ==  2500 & n_scheme == 10 ~ 10,
                                                                size ==  2500 & n_scheme == 35 ~ 35,
                                                                size ==  2500 & n_scheme == 75 ~ 75,
                                                                size ==  7500 & n_scheme == 4 ~ 10,
                                                                size ==  7500 & n_scheme == 12 ~ 35,
                                                                size ==  7500 & n_scheme == 25 ~ 75, 
                                                                size == 20000 & n_scheme == 2 ~ 10,
                                                                size == 20000 & n_scheme == 5 ~ 35,
                                                                size == 20000 & n_scheme == 10 ~ 75))

deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, metric) %>%
  dplyr::summarise(mse_rel_mean  = mean(mse_rel_mean, na.rm = TRUE), 
                   mse_rel_minmax = mean(mse_rel_minmax, na.rm = TRUE), 
                   rmse_rel_mean  = mean(rmse_rel_mean, na.rm = TRUE), 
                   rmse_rel_minmax = mean(rmse_rel_minmax, na.rm = TRUE), 
                   type_lsm = unique(type_lsm))

results_landscape <- dplyr::filter(deviation_summarised, level == "landscape") %>%
  tidyr::unite(unique_label,
               percentage, shape, type_scheme,
               remove = FALSE) %>% 
  dplyr::arrange(type_scheme, shape, percentage)

results_landscape$unique_label <- factor(results_landscape$unique_label, 
                                         levels = unique(results_landscape$unique_label))

ggplot_metrics <- ggplot(data = results_landscape, 
                         aes(x = metric, y = unique_label)) +
  geom_tile(aes(fill = rmse_rel_mean)) + 
  facet_wrap(~ autocorrelation + type_lsm, 
             scales = "free_x", 
             ncol = 6, nrow = 3) +
  scale_fill_viridis_c() + 
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
                   suffix = c("_deviation", "_scheme")) %>% 
  dplyr::left_join(landscapemetrics::lsm_abbreviations_names, 
                 by = "metric", 
                 suffix = c("_scheme", "_lsm"))

deviation_joined <- dplyr::mutate(deviation_joined, 
                                  percentage = dplyr::case_when(size ==  2500 & n_scheme == 10 ~ 10,
                                                                size ==  2500 & n_scheme == 35 ~ 35,
                                                                size ==  2500 & n_scheme == 75 ~ 75,
                                                                size ==  7500 & n_scheme == 4 ~ 10,
                                                                size ==  7500 & n_scheme == 12 ~ 35,
                                                                size ==  7500 & n_scheme == 25 ~ 75, 
                                                                size == 20000 & n_scheme == 2 ~ 10,
                                                                size == 20000 & n_scheme == 5 ~ 35,
                                                                size == 20000 & n_scheme == 10 ~ 75))

deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, type_lsm) %>%
  dplyr::summarise(mse_rel_mean  = mean(mse_rel_mean, na.rm = TRUE), 
                   mse_rel_minmax = mean(mse_rel_minmax, na.rm = TRUE), 
                   rmse_rel_mean  = mean(rmse_rel_mean, na.rm = TRUE), 
                   rmse_rel_minmax = mean(rmse_rel_minmax, na.rm = TRUE))

results_landscape <- dplyr::filter(deviation_summarised, level == "landscape") %>%
  tidyr::unite(unique_label,
               percentage, shape, type_scheme,
               remove = FALSE) %>% 
  dplyr::arrange(type_scheme, shape, percentage)

results_landscape$unique_label <- factor(results_landscape$unique_label, 
                                         levels = unique(results_landscape$unique_label))

ggplot_type <- ggplot(data = results_landscape, 
                      aes(x = type_lsm, y = unique_label)) +
  geom_tile(aes(fill = rmse_rel_mean)) + 
  facet_wrap(~ autocorrelation) +
  scale_fill_brewer(palette = ) +
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
                   suffix = c("_deviation", "_scheme")) %>% 
  dplyr::left_join(landscapemetrics::lsm_abbreviations_names, 
                   by = "metric", 
                   suffix = c("_scheme", "_lsm"))

deviation_joined <- dplyr::mutate(deviation_joined, 
                                  percentage = dplyr::case_when(size ==  2500 & n_scheme == 10 ~ 10,
                                                                size ==  2500 & n_scheme == 35 ~ 35,
                                                                size ==  2500 & n_scheme == 75 ~ 75,
                                                                size ==  7500 & n_scheme == 4 ~ 10,
                                                                size ==  7500 & n_scheme == 12 ~ 35,
                                                                size ==  7500 & n_scheme == 25 ~ 75, 
                                                                size == 20000 & n_scheme == 2 ~ 10,
                                                                size == 20000 & n_scheme == 5 ~ 35,
                                                                size == 20000 & n_scheme == 10 ~ 75))

deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, type_lsm) %>%
  dplyr::summarise(mse_rel = mean(mse_rel, na.rm = TRUE), 
                   rmse_rel = mean(rmse_rel, na.rm = TRUE))

results_landscape <- dplyr::filter(deviation_summarised, level == "landscape") %>%
  tidyr::unite(unique_label,
               percentage, shape, type_scheme,
               remove = FALSE) %>% 
  dplyr::arrange(type_scheme, shape, percentage)

results_landscape$unique_label <- factor(results_landscape$unique_label, 
                                         levels = unique(results_landscape$unique_label))

# Hypothesis 1
hypothesis_1_summarised <- results_landscape %>% 
  dplyr::group_by(autocorrelation, type_lsm, percentage) %>%
  dplyr::summarise(mse_rel = mean(mse_rel), 
                   rmse_rel = mean(rmse_rel))

hypothesis_1 <- aov(results_landscape$correct ~ as.factor(results_landscape$percentage))
summary(hypothesis_1)
TukeyHSD(hypothesis_1)

# Hypothesis 2
hypothesis_2_summarised <- results_landscape %>% 
  dplyr::group_by(autocorrelation, type_lsm, shape) %>%
  dplyr::summarise(mse_rel = mean(mse_rel), 
                   rmse_rel = mean(rmse_rel))

hypothesis_2 <- aov(results_landscape$correct ~ as.factor(results_landscape$shape))
summary(hypothesis_2)
TukeyHSD(hypothesis_2)

# Hypothesis 3
hypothesis_3_summarised <- results_landscape %>% 
  dplyr::group_by(autocorrelation,type_lsm, type_scheme)%>%
  dplyr::summarise(mse_rel = mean(mse_rel), 
                   rmse_rel = mean(rmse_rel))

random <- dplyr::filter(results_landscape, type.scheme == "random") %>% dplyr::pull(correct)
regular <- dplyr::filter(results_landscape, type.scheme == "regular") %>% dplyr::pull(correct)

t.test(random, regular)

