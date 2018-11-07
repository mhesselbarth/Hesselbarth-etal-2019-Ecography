# simulate landscapes with low, medium or high spatial autocorrelation

simulate_landscapes <- function(ac, user_seed) {
  
  # set different autocorrelation fract_dims
  if (ac == "low") {
    fract_dim <- 0.2
  }
  
  else if (ac == "medium") {
    fract_dim <- 1.0
  }
  
  else if (ac == "high") {
    fract_dim <- 1.5
  }
  
  else {stop("Please select ac = 'low', 'medium' or 'high'")}
  
  # create landscape and classify into 5 discrete classes
  landscapetools::util_classify(
    NLMR::nlm_fbm(ncol = 500,
                  nrow = 500,
                  fract_dim =  fract_dim,
                  user_seed = user_seed, 
                  verbose = FALSE),
    weighting = c(0.2, 0.2, 0.2, 0.2, 0.2))
}