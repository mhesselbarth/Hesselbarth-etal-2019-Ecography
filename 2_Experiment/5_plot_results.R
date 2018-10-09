
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

deviation_low_ac_landscape <- dplyr::filter(deviation_low_ac, level == "landscape") %>% 
  dplyr::left_join(unique(simulation_design[, -5]), 
                   by = c("simulation_id" = "id"), 
                   suffix = c(".dev", ".scheme")) %>% 
  dplyr::mutate(sampled_area = size * n.scheme)
  dplyr::group_by(level) %>%
  dplyr::arrange(sampled_area, .by_group = TRUE)

ggplot2::ggplot(data = deviation_low_ac_landscape) + 
  ggplot2::geom_point(ggplot2::aes(x = sampled_area, y = correct, 
                                   col = type.scheme, shape = shape)) + 
  ggplot2::facet_wrap(~ type.dev)
