# Wrapper around calculate_lsm that not all options must be set for Q() on HPC

calculate_lsm_helper <- function(landscape, i,  what) {
  landscapemetrics::calculate_lsm(landscape = landscape[[i]], 
                                  what = what,
                                  classes_max = 5,
                                  verbose = FALSE)
}
