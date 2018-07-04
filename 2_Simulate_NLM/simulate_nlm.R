# Simulate landscapes and classify into 5 land cover types
landscape_low_autocorrelation <-
  nlm_fbm(100, 100, fract_dim = 0.1) %>%
  util_classify(weighting = c(0.1, 0.15, 0.4, 0.05, 0.3))

landscape_medium_autocorrelation <-
  nlm_fbm(100, 100, fract_dim = 0.7) %>%
  util_classify(weighting = c(0.1, 0.15, 0.4, 0.05, 0.3))

landscape_high_autocorrelation <-
  nlm_fbm(100, 100, fract_dim = 1.4) %>%
  util_classify(weighting = c(0.1, 0.15, 0.4, 0.05, 0.3))
