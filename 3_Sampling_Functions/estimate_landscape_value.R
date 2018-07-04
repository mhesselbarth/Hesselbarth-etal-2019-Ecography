# Function to estimate landscape value incuding mean, se and confidence intervalls

estimate_landscape_value <- function(data, n, alpha = 1.96){
  data %>%
    dplyr::group_by(metric) %>%
    summarise(mean = mean(value), 
            sd = sd(value), 
            ci = alpha *  (sd / sqrt(n)),
            lo = mean - ci, 
            hi = mean + ci)
}

