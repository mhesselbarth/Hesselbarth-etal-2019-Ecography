# Function to estimate landscape value incuding mean, se and confidence intervalls

estimate_landscape_value <- function(data, alpha = 1.96){
  data %>%
    dplyr::group_by(simulation_run, simulation_design, metric) %>%
    dplyr::summarise(
      n = n(),
      mean = mean(value), 
      sd = sd(value), 
      ci = alpha *  (sd / sqrt(n)),
      lo = mean - ci, 
      hi = mean + ci)
}

