#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

simulation_design$id <- rep(1:(nrow(simulation_design) / 50), times = 50)

overwrite <- FALSE

library(patchwork)

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


# Create one full dataset
deviation_complete_ac <- dplyr::bind_rows(deviation_low_ac, deviation_medium_ac, deviation_high_ac)
deviation_complete_ac$autocorrelation <- factor(deviation_complete_ac$autocorrelation, 
                                                levels = c("low", "medium", "high"),
                                                labels = c("low spatial autocorrelation",
                                                "medium spatial autocorrelation",
                                                "high spatial autocorrelation"))

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

deviation_joined <- dplyr::filter(deviation_joined, level == "landscape")

#### 3. Summarised by metrics ####
deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, metric) %>%
  dplyr::summarise(mse_median = median(mse, na.rm = TRUE) * 100, 
                   rmse_median = median(rmse, na.rm = TRUE) * 100, 
                   nrmse_median = median(nrmse, na.rm = TRUE) * 100, 
                   type_lsm = unique(type_lsm))

results <- tidyr::unite(deviation_summarised, 
                        unique_label,
                        percentage, shape, type_scheme,
                        remove = FALSE) %>% 
  dplyr::arrange(type_scheme, shape, percentage)

results$unique_label <- factor(results$unique_label, 
                               levels = unique(results$unique_label))

ggplot_metrics <- ggplot(data = results, 
                         aes(x = metric, y = unique_label)) +
  geom_tile(aes(fill = nrmse_median)) + 
  geom_text(aes(label = round(nrmse_median, 2)), col = "black", size = 2) +
  facet_wrap(~ autocorrelation + type_lsm, 
             scales = "free_x", 
             ncol = 6, nrow = 3) +
  scale_fill_viridis_c(name = "nRMSE [%]") + 
  labs(x = "Landscape metrics", y = "Sample scheme") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # +
  # theme_ipsum(axis_title_size = 14, axis.text.x = element_text(angle = 45, hjust = 1))

# ggsave("4_Plots/ggplot_metrics.png", width = 12, height = 28)

# UtilityFunctions::save_ggplot(ggplot_metrics,
#                               filename = "ggplot_metrics.png",
#                               path = paste0(getwd(), "/4_Plots"),
#                               overwrite = overwrite,
#                               width = 18, height = 28, units = "cm")

#### 4. Clean data ####
deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, metric) %>%
  dplyr::summarise(mse_median = median(mse, na.rm = TRUE) * 100, 
                   rmse_median = median(rmse, na.rm = TRUE) * 100, 
                   nrmse_median = median(nrmse, na.rm = TRUE) * 100, 
                   type_lsm = unique(type_lsm))

metric_list <- split(deviation_summarised, deviation_summarised$metric) %>% 
  purrr::map(function(x) { 
    all(x$nrmse_median >= 125)
  }) 
metric_list <- unique(deviation_joined$metric)[purrr::flatten_lgl(metric_list)]

deviation_cleaned <- dplyr::filter(deviation_joined, !(metric %in% metric_list))

#### 5. Summarised by type ####
deviation_summarised <- dplyr::group_by(deviation_cleaned, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, type_lsm) %>%
  dplyr::summarise(mse_median  = median(mse, na.rm = TRUE) * 100, 
                   rmse_median  = median(rmse, na.rm = TRUE) * 100, 
                   nrmse_median = median(nrmse, na.rm = TRUE) * 100)

results <- tidyr::unite(deviation_summarised, 
                        unique_label,
                        percentage, shape, type_scheme,
                        remove = FALSE) %>% 
  dplyr::arrange(type_scheme, shape, percentage)

results$unique_label <- factor(results$unique_label, 
                               levels = unique(results$unique_label))

ggplot_type <- ggplot(data = results, 
                      aes(x = type_lsm, y = unique_label)) +
  geom_tile(aes(fill = nrmse_median)) + 
  geom_text(aes(label = round(nrmse_median, 2)), col = "black", size = 2.5) +
  facet_wrap(~ autocorrelation, ncol = 1) +
  scale_fill_viridis_c(name = "nRMSE [%]") + 
  labs(x = "Landscape metrics", y = "Sample scheme") +
  theme_light() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.border = element_blank()) 

# ggsave("4_Plots/ggplot_type.png", width = 12, height = 28)
# ggsave("4_Plots/ggplot_type.eps", width = 14, height = 28)

#### 5. Hypotheses ####
deviation_cleaned <- dplyr::filter(deviation_cleaned, is.finite(nrmse))

# Hypothesis 1
hypothesis_1_summarised <- dplyr::group_by(deviation_cleaned, 
                                           autocorrelation, percentage)  %>%
  dplyr::summarise(n = n(),
                   mean = mean(nrmse, na.rm = TRUE) * 100, 
                   median = median(nrmse, na.rm = TRUE) * 100,
                   lower = quantile(nrmse, probs = 0.25, na.rm = TRUE) * 100, 
                   upper = quantile(nrmse, probs = 0.75, na.rm = TRUE) * 100, 
                   min = quantile(nrmse, probs = 0.1, na.rm = TRUE) * 100, 
                   max = quantile(nrmse, probs = 0.9, na.rm = TRUE) * 100) 

ggplot_hypothesis_1 <- ggplot(data = hypothesis_1_summarised) +
  geom_boxplot(aes(x = as.factor(percentage), 
                   lower = lower,
                   upper = upper, 
                   middle = median, 
                   ymin = min, 
                   ymax = max), 
               stat = "identity") + 
  facet_wrap(~ autocorrelation, scales = "free_y",
             ncol = 6, nrow = 3)  +
  labs(x = "Sampled landscape [%]", y = "nRMSE [%]") # +
  # theme_ipsum(axis_title_size = 14)

# Hypothesis 2
hypothesis_2_summarised <- dplyr::group_by(deviation_joined, 
                                           autocorrelation, shape)  %>%
  dplyr::summarise(mean = mean(nrmse, na.rm = TRUE) * 100, 
                   median = median(nrmse, na.rm = TRUE) * 100,
                   lower = quantile(nrmse, probs = 0.25, na.rm = TRUE) * 100, 
                   upper = quantile(nrmse, probs = 0.75, na.rm = TRUE) * 100, 
                   min = quantile(nrmse, probs = 0.1, na.rm = TRUE) * 100, 
                   max = quantile(nrmse, probs = 0.9, na.rm = TRUE) * 100)

ggplot_hypothesis_2 <- ggplot(data = hypothesis_2_summarised) +
  geom_boxplot(aes(x = factor(shape, levels = c("rectangle", "square", "circle")), 
                   lower = lower,
                   upper = upper, 
                   middle = median, 
                   ymin = min, 
                   ymax = max), 
               stat = "identity") + 
  facet_wrap(~ autocorrelation, scales = "free_y",
             ncol = 6, nrow = 3) +
  labs(x = "Plot shape", y = "nRMSE [%]") # +
  # theme_ipsum(axis_title_size = 14)


# Hypothesis 3
hypothesis_3_summarised <- dplyr::group_by(deviation_joined, 
                                           autocorrelation, type_scheme)  %>%
  dplyr::summarise(n = n(), 
                   mean = mean(nrmse, na.rm = TRUE) * 100, 
                   median = median(nrmse, na.rm = TRUE) * 100,
                   lower = quantile(nrmse, probs = 0.25, na.rm = TRUE) * 100, 
                   upper = quantile(nrmse, probs = 0.75, na.rm = TRUE) * 100, 
                   min = quantile(nrmse, probs = 0.1, na.rm = TRUE) * 100, 
                   max = quantile(nrmse, probs = 0.9, na.rm = TRUE) * 100)

ggplot_hypothesis_3 <- ggplot(data = hypothesis_3_summarised) +
  geom_boxplot(aes(x = factor(type_scheme, levels = c("random", "regular")), 
                   lower = lower,
                   upper = upper, 
                   middle = median, 
                   ymin = min, 
                   ymax = max), 
               stat = "identity") + 
  facet_wrap(~ autocorrelation, scales = "free_y",
             ncol = 6, nrow = 3) +
  labs(x = "Spatial arrangement plots", y = "nRMSE [%]") # +
  # theme_ipsum(axis_title_size = 14)

ggplot_hypothesis_1 +
  ggplot_hypothesis_2 +
  ggplot_hypothesis_3 +
  plot_layout(ncol = 1) +
  patchwork::plot_annotation(tag_levels = "a", tag_suffix = ")")

ggsave("4_Plots/ggplot_hypotheses.png", width = 12, height = 20)
ggsave("4_Plots/ggplot_hypotheses.eps", width = 14, height = 20)
