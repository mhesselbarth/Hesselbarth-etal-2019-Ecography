
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

absolute_metrics <- c("ca", "ndca", "np", "pafrac", "pr", "ta", "tca", "te")

simulation_design$id <- rep(1:(nrow(simulation_design) / 25), times = 25)

overwrite <- FALSE

#### 1. Low AC ####

sampling_low_ac <- readr::read_rds(path = paste0(getwd(), 
                                                 "/3_Output/sampling_low_ac_25.rds"))

true_value_low_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_low_ac_25.rds"))

for(i in 1:length(true_value_low_ac)) {
  true_value_low_ac[[i]] <- dplyr::filter(true_value_low_ac[[i]], 
                level != "patch" & !(metric %in% absolute_metrics))
  
  true_value_low_ac[[i]] <- dplyr::mutate(true_value_low_ac[[i]], layer = i)
}

true_value_low_ac <- dplyr::bind_rows(true_value_low_ac)

for(i in 1:length(sampling_low_ac)) {
  for(j in 1:length(sampling_low_ac[[i]]$metrics)) {
    sampling_low_ac[[i]]$metrics[[j]] <-  dplyr::filter(sampling_low_ac[[i]]$metrics[[j]],
                                                        level != "patch" & !(metric %in% absolute_metrics))

    sampling_low_ac[[i]]$metrics[[j]] <- dplyr::mutate(sampling_low_ac[[i]]$metrics[[j]], 
                                                       landscape_id = simulation_design$i[i],
                                                       simulation_id = simulation_design$id[i])
  }
}

deviation_low_ac <- bind_rows(sampling_low_ac) %>% 
  unnest(metrics) %>%
  dplyr::group_by(simulation_id, landscape_id, level, class, metric) %>%
  dplyr::summarise(mean = mean(value, na.rm = TRUE),
                   sd = sd(value, na.rm = TRUE),
                   ci = 1.96 *  (sd / sqrt(n())),
                   lo = mean - ci,
                   hi = mean + ci) %>%
  dplyr::left_join(true_value_low_ac, 
                   by = c("landscape_id" = "layer", 
                          "level" = "level",
                          "class" = "class",
                          "metric" = "metric")) %>%
  dplyr::mutate(inside_ci = dplyr::case_when(lo <= value & value <= hi ~ 1, 
                                             lo > value | hi < value ~ 0, 
                                             is.nan(sd) ~ 0), 
                deviation_rel = (mean - value) / value) %>% 
  dplyr::left_join(landscapemetrics::lsm_abbreviations_names, 
                   by = "metric")

UtilityFunctions::save_rds(object = deviation_low_ac, 
                           filename = "deviation_low_ac_25.rds", 
                           path = paste0(getwd(), "/3_Output"),
                           overwrite = overwrite)

# rm(sampling_low_ac, true_value_low_ac)

#### 2. Medium AC ####

sampling_medium_ac <- readr::read_rds(path = paste0(getwd(), 
                                                 "/3_Output/sampling_medium_ac_25.rds"))

true_value_medium_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_medium_ac_25.rds"))

for(i in 1:length(true_value_medium_ac)) {
  true_value_medium_ac[[i]] <- dplyr::filter(true_value_medium_ac[[i]], 
                                          level != "patch" & !(metric %in% absolute_metrics))
  
  true_value_medium_ac[[i]] <- dplyr::mutate(true_value_medium_ac[[i]], layer = i)
}

true_value_medium_ac <- dplyr::bind_rows(true_value_medium_ac)

for(i in 1:length(sampling_medium_ac)) {
  for(j in 1:length(sampling_medium_ac[[i]]$metrics)) {
    sampling_medium_ac[[i]]$metrics[[j]] <-  dplyr::filter(sampling_medium_ac[[i]]$metrics[[j]],
                                                        level != "patch" & !(metric %in% absolute_metrics))
    
    sampling_medium_ac[[i]]$metrics[[j]] <- dplyr::mutate(sampling_medium_ac[[i]]$metrics[[j]], 
                                                       landscape_id = simulation_design$i[i],
                                                       simulation_id = simulation_design$id[i])
  }
}

deviation_medium_ac <- bind_rows(sampling_medium_ac) %>% 
  unnest(metrics) %>%
  dplyr::group_by(simulation_id, landscape_id, level, class, metric) %>%
  dplyr::summarise(n = n(),
                   mean = mean(value, na.rm = TRUE),
                   sd = sd(value, na.rm = TRUE),
                   ci = 1.96 *  (sd / sqrt(n)),
                   lo = mean - ci,
                   hi = mean + ci) %>%
  dplyr::left_join(true_value_medium_ac, 
                   by = c("landscape_id" = "layer", 
                          "level" = "level",
                          "class" = "class",
                          "metric" = "metric")) %>%
  dplyr::mutate(inside_ci = dplyr::case_when(lo <= value & value <= hi ~ 1, 
                                             lo > value | hi < value ~ 0,
                                             is.nan(sd) ~ 0),
                deviation_rel = (mean - value) / value) %>% 
  dplyr::left_join(landscapemetrics::lsm_abbreviations_names, 
                   by = "metric")

UtilityFunctions::save_rds(object = deviation_medium_ac, 
                           filename = "deviation_medium_ac_25.rds", 
                           path = paste0(getwd(), "/3_Output"),
                           overwrite = overwrite)

# rm(sampling_medium_ac, true_value_medium_ac)

#### 3. High AC ####

# high AC
sampling_high_ac <- readr::read_rds(path = paste0(getwd(), 
                                                 "/3_Output/sampling_high_ac_25.rds"))

true_value_high_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_high_ac_25.rds"))

for(i in 1:length(true_value_high_ac)) {
  true_value_high_ac[[i]] <- dplyr::filter(true_value_high_ac[[i]], 
                                          level != "patch" & !(metric %in% absolute_metrics))
  
  true_value_high_ac[[i]] <- dplyr::mutate(true_value_high_ac[[i]], layer = i)
}

true_value_high_ac <- dplyr::bind_rows(true_value_high_ac)

for(i in 1:length(sampling_high_ac)) {
  for(j in 1:length(sampling_high_ac[[i]]$metrics)) {
    sampling_high_ac[[i]]$metrics[[j]] <-  dplyr::filter(sampling_high_ac[[i]]$metrics[[j]],
                                                        level != "patch" & !(metric %in% absolute_metrics))
    
    sampling_high_ac[[i]]$metrics[[j]] <- dplyr::mutate(sampling_high_ac[[i]]$metrics[[j]], 
                                                       landscape_id = simulation_design$i[i],
                                                       simulation_id = simulation_design$id[i])
  }
}

deviation_high_ac <- bind_rows(sampling_high_ac) %>% 
  unnest(metrics) %>%
  dplyr::group_by(simulation_id, landscape_id, level, class, metric) %>%
  dplyr::summarise(n = n(),
                   mean = mean(value, na.rm = TRUE),
                   sd = sd(value, na.rm = TRUE),
                   ci = 1.96 *  (sd / sqrt(n)),
                   lo = mean - ci,
                   hi = mean + ci) %>%
  dplyr::left_join(true_value_high_ac, 
                   by = c("landscape_id" = "layer", 
                          "level" = "level",
                          "class" = "class",
                          "metric" = "metric")) %>%
  dplyr::mutate(inside_ci = dplyr::case_when(lo <= value & value <= hi ~ 1, 
                                             lo > value | hi < value ~ 0,
                                             is.nan(sd) ~ 0),
                deviation_rel = (mean - value) / value) %>% 
  dplyr::left_join(landscapemetrics::lsm_abbreviations_names, 
                   by = "metric")

UtilityFunctions::save_rds(object = deviation_high_ac, 
                           filename = "deviation_high_ac_25.rds", 
                           path = paste0(getwd(), "/3_Output"),
                           overwrite = overwrite)

# rm(sampling_high_ac, true_value_high_ac)
