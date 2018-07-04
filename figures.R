set.seed(42)

source("1_Setup/1_load_packages.R")
source("2_Simulate_NLM/simulate_nlm.R")


util_plot(list("Low Autocorrelation"    = landscape_low_autocorrelation,
               "Medium Autocorrelation" = landscape_medium_autocorrelation,
               "High Autocorrelation"   = landscape_high_autocorrelation))
