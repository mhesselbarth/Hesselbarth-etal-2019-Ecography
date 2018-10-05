# Wrapper around calculate_lsm that not all options must be set for Q()

calculate_lsm_helper <- function(landscape, i,  what, classes_max, verbose) {
  landscapemetrics::calculate_lsm(landscape = landscape[[i]], 
                                  what = what,
                                  classes_max = classes_max,
                                  verbose = verbose)
}
