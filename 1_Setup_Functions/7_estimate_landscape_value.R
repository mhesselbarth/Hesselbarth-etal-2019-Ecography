# Function to estimate landscape value incuding mean, se and confidence intervalls

estimate_landscape_value <- function(x, alpha = 1.96){
  
  df_grouped <- dplyr::group_by(x, level, metric)
  
  dplyr::summarise(df_grouped, 
                   n = n(),
                   mean = mean(value, na.rm = TRUE),
                   sd = sd(value, na.rm = TRUE),
                   ci = alpha *  (sd / sqrt(n)),
                   lo = mean - ci,
                   hi = mean + ci)
}