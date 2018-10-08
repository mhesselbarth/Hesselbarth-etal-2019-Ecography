
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

#### 2. Import results #### 

# Low AC
sampling_low_ac <- readr::read_rds(path = paste0(getwd(), 
                                                 "/3_Output/sampling_low_ac.rds"))

true_value_low_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_low_ac.rds"))

# Medium AC
sampling_medium_ac <- readr::read_rds(path = paste0(getwd(),
                                                   "/3_Output/sampling_medium_ac.rds"))

true_value_medium_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_medium_ac.rds"))

# High AC
sampling_high_ac <- readr::read_rds(path = paste0(getwd(),
                                                 "/3_Output/sampling_high_ac.rds"))

true_value_high_ac <- readr::read_rds(path = paste0(getwd(), 
                                                   "/3_Output/true_value_high_ac.rds"))




#### 3. Select only comparable metrics

absolute_metrics <- c("ca", "ndca", "np", "pafrac", "pr", "ta", "tca", "te")

# Low AC
filtered_true_value_low_ac <- purrr::map(seq_along(true_value_low_ac), function(current_landscape) { 
  
  df_filtered <- dplyr::filter(true_value_low_ac[[current_landscape]], 
                               level != "patch" & !(metric %in% absolute_metrics))
  
  dplyr::mutate(df_filtered, i = current_landscape)
})

filtered_sampling_low_ac <- purrr::map(seq_along(sampling_low_ac), function(current_sampling) { 
  
  df_filtered <- dplyr::filter(sampling_low_ac[[current_sampling]], 
                               level != "patch" & !(metric %in% absolute_metrics))
  
  dplyr::mutate(df_filtered, i = simulation_design$i[current_sampling])
})


# Medium AC
filtered_true_value_medium_ac <- purrr::map(seq_along(true_value_medium_ac), function(current_landscape) { 
  
  df_filtered <- dplyr::filter(true_value_medium_ac[[current_landscape]], 
                               level != "patch" & !(metric %in% absolute_metrics))
  
  dplyr::mutate(df_filtered, i = current_landscape)
})

filtered_sampling_medium_ac <- purrr::map(seq_along(sampling_medium_ac), function(current_sampling) { 
  
  df_filtered <- dplyr::filter(sampling_medium_ac[[current_sampling]], 
                               level != "patch" & !(metric %in% absolute_metrics))
  
  dplyr::mutate(df_filtered, i = simulation_design$i[current_sampling])
})


# High AC
filtered_true_value_high_ac <- purrr::map(seq_along(true_value_high_ac), function(current_landscape) { 
  
  df_filtered <- dplyr::filter(true_value_high_ac[[current_landscape]], 
                               level != "patch" & !(metric %in% absolute_metrics))
  
  dplyr::mutate(df_filtered, i = current_landscape)
})

filtered_sampling_high_ac <- purrr::map(seq_along(sampling_high_ac), function(current_sampling) { 
  
  df_filtered <- dplyr::filter(sampling_high_ac[[current_sampling]], 
                               level != "patch" & !(metric %in% absolute_metrics))
  
  dplyr::mutate(df_filtered, i = simulation_design$i[current_sampling])
})

#### 4. Calculate sample estimation #### 

purrr::map(filtered_sampling_high_ac, function(x) { 
  estimate_landscape_value(x)
})


# Low AC
percentage_low_ac <- sampling_low_ac %>%
  estimate_landscape_value() %>%
  dplyr::left_join(true_value_low_ac, 
                   by = c("simulation_run" = "layer", "metric")) %>% 
  dplyr::mutate(within_ci = dplyr::case_when(value > lo & value < hi ~ 1, 
                                             value < lo ~ 0, 
                                             value > hi ~ 0)) %>%
  dplyr::group_by(simulation_design) %>%
  dplyr::summarise(n = (sum(within_ci) / n()) * 100)

# Medium AC
percentage_medium_ac <- sampling_medium_ac %>%
  estimate_landscape_value() %>%
  dplyr::left_join(true_value_medium_ac,
                   by = c("simulation_run" = "layer", "metric")) %>%
  dplyr::mutate(within_ci = dplyr::case_when(value > lo & value < hi ~ 1,
                                             value < lo ~ 0,
                                             value > hi ~ 0)) %>%
  dplyr::group_by(simulation_design) %>%
  dplyr::summarise(n = (sum(within_ci) / n()) * 100)

# High AC
percentage_high_ac <- sampling_high_ac %>%
  estimate_landscape_value() %>%
  dplyr::left_join(true_value_high_ac,
                   by = c("simulation_run" = "layer", "metric")) %>%
  dplyr::mutate(within_ci = dplyr::case_when(value > lo & value < hi ~ 1,
                                             value < lo ~ 0,
                                             value > hi ~ 0)) %>%
  dplyr::group_by(simulation_design) %>%
  dplyr::summarise(n = (sum(within_ci) / n()) * 100)

#### 4. Save Results ####

# Low AC
UtilityFunctions::Save.Function.rds(object = percentage_low_ac, 
                                    filename = "percentage_low_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"), 
                                    overwrite = FALSE)

# Medium AC
UtilityFunctions::Save.Function.rds(object = sampling_medium_ac, 
                                    filename = "percentage_medium_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)

# High AC
UtilityFunctions::Save.Function.rds(object = percentage_high_ac, 
                                    filename = "percentage_high_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"),
                                    overwrite = FALSE)

