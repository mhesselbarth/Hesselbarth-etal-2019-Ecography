
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
                   suffix = c(".dev", ".scheme"))

aggregation_metrics <- dplyr::filter(deviation_low_ac_landscape, type.dev == "aggregation metric" & type.scheme == "random")
aggregation_metrics$shape <- as.numeric(as.factor(aggregation_metrics$shape))

aggregation_metrics <- dplyr::mutate(aggregation_metrics, 
              size = case_when(size == 100 ~ 1, 
                               size == 1250 ~ 2, 
                               size == 7500 ~ 3), 
              n.scheme = case_when(n.scheme == 10 ~ 1, 
                                   n.scheme == 25 ~ 2, 
                                   n.scheme == 50 ~ 3))
            
breaks = c(1,2,3)

ggtern(data = aggregation_metrics, aes(x = n.scheme, 
                                       y = size, 
                                       z = shape, 
                                       color = correct)) + 
  geom_point(size = 5)