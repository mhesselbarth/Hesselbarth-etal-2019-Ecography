# functions to simulate landscapes with low to high spatial
# autocorrelation

landscape_high_autocorrelation <- function(seed) {
  nlm_fbm(500,
          500,
          fract_dim =  1.5,
          user_seed = seed, 
          verbose = FALSE) %>%
    util_classify(weighting = c(0.2, 0.2, 0.2, 0.2, 0.2))
}

landscape_medium_autocorrelation <- function(seed) {
  nlm_fbm(500,
          500,
          fract_dim =  1.0,
          user_seed = seed,
          verbose = FALSE) %>%
    util_classify(weighting = c(0.2, 0.2, 0.2, 0.2, 0.2))
}

landscape_low_autocorrelation <- function(seed) {
  nlm_fbm(500,
          500,
          fract_dim =  0.2,
          user_seed = seed,
          verbose = FALSE) %>%
    util_classify(weighting = c(0.2, 0.2, 0.2, 0.2, 0.2))
}