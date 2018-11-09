#### 1. Load libraries and source functions #### 
library(dplyr)
library(ggplot2)
library(landscapemetrics)
library(purrr)
library(UtilityFunctions) # devtools::install_github("mhesselbarth/UtilityFunctions")
library(readr)
library(tidyr)

purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

simulation_design$id <- rep(1:(nrow(simulation_design) / 50), times = 50)

overwrite <- FALSE

library(patchwork)

#### 2. Import results #### 

# Low AC
deviation_low_ac <- readr::read_rds(paste0(getwd(), 
                                           "/3_Output/deviation_low_ac_50.rds"))

deviation_low_ac$autocorrelation <- "low"

# Medium AC
deviation_medium_ac <- readr::read_rds(paste0(getwd(), 
                                              "/3_Output/deviation_medium_ac_50.rds"))

deviation_medium_ac$autocorrelation <- "medium"

# High AC
deviation_high_ac <- readr::read_rds(paste0(getwd(), 
                                            "/3_Output/deviation_high_ac_50.rds"))

deviation_high_ac$autocorrelation <- "high"


# Create one full dataset
deviation_complete_ac <- dplyr::bind_rows(deviation_low_ac, deviation_medium_ac, deviation_high_ac)
deviation_complete_ac$autocorrelation <- factor(deviation_complete_ac$autocorrelation, 
                                                levels = c("low", "medium", "high"),
                                                labels = c("low spatial autocorrelation",
                                                           "medium spatial autocorrelation",
                                                           "high spatial autocorrelation"))

# join with sampling scheme variables and lansdcape metric groups according to FRAGSTATS
deviation_joined <- dplyr::filter(deviation_complete_ac, level == "landscape") %>% 
  dplyr::left_join(unique(simulation_design[, -5]), 
                   by = c("simulation_id" = "id"), 
                   suffix = c("_deviation", "_scheme")) %>% 
  dplyr::left_join(landscapemetrics::lsm_abbreviations_names, 
                   by = "metric", 
                   suffix = c("_scheme", "_lsm"))

# because number of plots is different, the area sampled is set here to same value for later grouping
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

#### 3. Summarised by metrics ####
# Summarise nrmse for each metric
deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, metric) %>%
  dplyr::summarise(mse_median = median(mse, na.rm = TRUE) * 100, 
                   rmse_median = median(rmse, na.rm = TRUE) * 100, 
                   nrmse_median = median(nrmse, na.rm = TRUE) * 100, 
                   type_lsm = unique(type_lsm))

# Create unique label from sampling scheme variables
results <- tidyr::unite(deviation_summarised, 
                        unique_label,
                        percentage, shape, type_scheme,
                        remove = FALSE) %>% 
  dplyr::arrange(type_scheme, shape, percentage)

results$unique_label <- factor(results$unique_label, 
                               levels = unique(results$unique_label))

# relabel type_lsm
results$type_lsm <- case_when(
  results$type_lsm == "aggregation metric"   ~ "aggregation metrics",
  results$type_lsm == "area and edge metric" ~ "area and edge metrics",
  results$type_lsm == "core area metric"     ~ "core area metrics",
  results$type_lsm == "diversity metric"     ~ "diversity metrics",
  results$type_lsm == "new metric"           ~ "complexity metrics",
  results$type_lsm == "shape metric"         ~ "shape metrics",
  TRUE ~ as.character(results$type_lsm)
)

# plot result
ggplot_metrics <- ggplot(data = results, 
                         aes(x = metric, y = unique_label)) +
  geom_tile(aes(fill = nrmse_median)) + 
  geom_text(aes(label = round(nrmse_median, 1)), col = "black", size = 1.75) +
  facet_wrap(~ autocorrelation + type_lsm, 
             scales = "free_x", 
             ncol = 6, nrow = 3) +
  scale_fill_viridis_c(name = "nRMSE [%]") + 
  labs(x = "Landscape metrics", y = "Sample scheme") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        text = element_text(size = 12.5), 
        panel.border = element_blank())

# ggsave("4_Plots/ggplot_metrics.png", width = 15, height = 18)
# UtilityFunctions::save_ggplot(ggplot_metrics,
#                               filename = "ggplot_metrics.png",
#                               path = paste0(getwd(), "/4_Plots"),
#                               overwrite = overwrite,
#                               width = 18, height = 28, units = "cm")

#### 4. Clean data ####
# Summarise nrmse for each metric
deviation_summarised <- dplyr::group_by(deviation_joined, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, metric) %>%
  dplyr::summarise(mse_median = median(mse, na.rm = TRUE) * 100, 
                   rmse_median = median(rmse, na.rm = TRUE) * 100, 
                   nrmse_median = median(nrmse, na.rm = TRUE) * 100, 
                   type_lsm = unique(type_lsm))

# remove metrics with nRMSE > 125 for all sampling schemes and autocorrelations
metric_list <- split(deviation_summarised, deviation_summarised$metric) %>% 
  purrr::map(function(x) { 
    all(x$nrmse_median >= 125)
  }) 
metric_list <- unique(deviation_joined$metric)[purrr::flatten_lgl(metric_list)]

deviation_cleaned <- dplyr::filter(deviation_joined, !(metric %in% metric_list))

# remove NA and INF
deviation_cleaned <- dplyr::filter(deviation_cleaned, is.finite(nrmse))

#### 5. Summarised by type ####
# summarise by landscape metric group according to FRAGSTATS
deviation_summarised <- dplyr::group_by(deviation_cleaned, 
                                        autocorrelation, percentage, shape, type_scheme, level, class, type_lsm) %>%
  dplyr::summarise(mse_median  = median(mse, na.rm = TRUE) * 100, 
                   rmse_median  = median(rmse, na.rm = TRUE) * 100, 
                   nrmse_median = median(nrmse, na.rm = TRUE) * 100)

# create unique label from variables of sampling scheme
results <- tidyr::unite(deviation_summarised, 
                        unique_label,
                        percentage, shape, type_scheme,
                        remove = FALSE) %>% 
  dplyr::arrange(type_scheme, shape, percentage)

results$unique_label <- factor(results$unique_label, 
                               levels = unique(results$unique_label))

# relabel type_lsm
results$type_lsm <- case_when(
  results$type_lsm == "aggregation metric"   ~ "aggregation metrics",
  results$type_lsm == "area and edge metric" ~ "area and edge metrics",
  results$type_lsm == "core area metric"     ~ "core area metrics",
  results$type_lsm == "diversity metric"     ~ "diversity metrics",
  results$type_lsm == "new metric"           ~ "complexity metrics",
  results$type_lsm == "shape metric"         ~ "shape metrics",
  TRUE ~ as.character(results$type_lsm)
)

# plot results
ggplot_type <- ggplot(data = results, 
                      aes(x = type_lsm, y = unique_label)) +
  geom_tile(aes(fill = nrmse_median)) + 
  geom_text(aes(label = round(nrmse_median, 2)), col = "black") +
  facet_wrap(~ autocorrelation, ncol = 1) +
  scale_fill_viridis_c(name = "nRMSE [%]") + 
  labs(x = "Landscape metrics", y = "Sample scheme") +
  theme_light() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        text = element_text(size = 15),
        panel.border = element_blank()) 

# ggsave("4_Plots/ggplot_type.png", width = 15, height = 18)
# ggsave("4_Plots/ggplot_type.eps", width = 14, height = 28)

### General analyses ####
# Metrics with a nRMSE > 125% for all sampling schemes
metric_list

# Median for autocorrelations
dplyr::group_by(deviation_cleaned, autocorrelation) %>% 
  summarise(median = median(nrmse, na.rm = TRUE) * 100) %>% 
  dplyr::arrange(median)

# Median for types
dplyr::group_by(deviation_cleaned, type_lsm) %>% 
  summarise(median = median(nrmse, na.rm = TRUE) * 100) %>% 
  dplyr::arrange(median)

# Percentage metrics nRMSE < 25%
dplyr::filter(deviation_cleaned, nrmse < 0.25) %>%
  dplyr::group_by(autocorrelation) %>%
  summarise(below_thres = (n() / (58 * 54 * 50) * 100)) %>% # 54 sampling schemes, 50 repetitions, 58 metrics
  dplyr::arrange(autocorrelation)

#### 5. Hypotheses ####

# Hypothesis 1
# summarise nRMSE by landscape sampled
dplyr::group_by(deviation_cleaned, percentage) %>%
  dplyr::summarise(median = median(nrmse, na.rm = TRUE) * 100)

# data for boxplot
hypothesis_1_summarised <- dplyr::group_by(deviation_cleaned, 
                                           autocorrelation, percentage)  %>%
  dplyr::summarise(n = n(),
                   mean = mean(nrmse, na.rm = TRUE) * 100, 
                   median = median(nrmse, na.rm = TRUE) * 100,
                   lower = quantile(nrmse, probs = 0.25, na.rm = TRUE) * 100, 
                   upper = quantile(nrmse, probs = 0.75, na.rm = TRUE) * 100, 
                   min = quantile(nrmse, probs = 0.1, na.rm = TRUE) * 100, 
                   max = quantile(nrmse, probs = 0.9, na.rm = TRUE) * 100) 

# create plot
ggplot_hypothesis_1 <- ggplot(data = hypothesis_1_summarised) +
  geom_boxplot(aes(x = as.factor(percentage), 
                   lower = lower,
                   upper = upper, 
                   middle = median, 
                   ymin = min, 
                   ymax = max), 
               stat = "identity") + 
  facet_wrap(~ autocorrelation, scales = "free_y",
             ncol = 3, nrow = 1)  +
  labs(x = "Sampled landscape [%]", y = "nRMSE [%]") + 
  theme_bw() +
  theme(text = element_text(size = 25))


# Hypothesis 2
# summarised by plot shape
dplyr::group_by(deviation_cleaned, shape) %>%
  dplyr::summarise(median = median(nrmse, na.rm = TRUE) * 100)

# data for boxplot
hypothesis_2_summarised <- dplyr::group_by(deviation_joined, 
                                           autocorrelation, shape)  %>%
  dplyr::summarise(mean = mean(nrmse, na.rm = TRUE) * 100, 
                   median = median(nrmse, na.rm = TRUE) * 100,
                   lower = quantile(nrmse, probs = 0.25, na.rm = TRUE) * 100, 
                   upper = quantile(nrmse, probs = 0.75, na.rm = TRUE) * 100, 
                   min = quantile(nrmse, probs = 0.1, na.rm = TRUE) * 100, 
                   max = quantile(nrmse, probs = 0.9, na.rm = TRUE) * 100)

# create plot
ggplot_hypothesis_2 <- ggplot(data = hypothesis_2_summarised) +
  geom_boxplot(aes(x = factor(shape, levels = c("rectangle", "square", "circle")), 
                   lower = lower,
                   upper = upper, 
                   middle = median, 
                   ymin = min, 
                   ymax = max), 
               stat = "identity") + 
  facet_wrap(~ autocorrelation, scales = "free_y",
             ncol = 3, nrow = 1) +
  labs(x = "Plot shape", y = "nRMSE [%]") + 
  theme_bw() +
  theme(text = element_text(size = 25))


# Hypothesis 3
# summarised by spatial arrangement of sampling plots
dplyr::group_by(deviation_cleaned, type_scheme) %>%
  dplyr::summarise(median = median(nrmse, na.rm = TRUE) * 100)

# data for boxplot
hypothesis_3_summarised <- dplyr::group_by(deviation_joined, 
                                           autocorrelation, type_scheme)  %>%
  dplyr::summarise(n = n(), 
                   mean = mean(nrmse, na.rm = TRUE) * 100, 
                   median = median(nrmse, na.rm = TRUE) * 100,
                   lower = quantile(nrmse, probs = 0.25, na.rm = TRUE) * 100, 
                   upper = quantile(nrmse, probs = 0.75, na.rm = TRUE) * 100, 
                   min = quantile(nrmse, probs = 0.1, na.rm = TRUE) * 100, 
                   max = quantile(nrmse, probs = 0.9, na.rm = TRUE) * 100)

# create plot
ggplot_hypothesis_3 <- ggplot(data = hypothesis_3_summarised) +
  geom_boxplot(aes(x = factor(type_scheme, levels = c("random", "regular")), 
                   lower = lower,
                   upper = upper, 
                   middle = median, 
                   ymin = min, 
                   ymax = max), 
               stat = "identity") + 
  facet_wrap(~ autocorrelation, scales = "free_y",
             ncol = 3, nrow = 1) +
  labs(x = "Spatial arrangement plots", y = "nRMSE [%]") + 
  theme_bw() +
  theme(text = element_text(size = 25))

# Create one large plot
ggplot_hypothesis_1 +
  ggplot_hypothesis_2 +
  ggplot_hypothesis_3 +
  plot_layout(ncol = 1) +
  patchwork::plot_annotation(tag_levels = "a", tag_suffix = ")")

ggsave("4_Plots/ggplot_hypotheses.png", width = 15, height = 18)
# ggsave("4_Plots/ggplot_hypotheses.eps", width = 14, height = 20)
