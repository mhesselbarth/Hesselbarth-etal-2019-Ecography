# Simulate landscapes and classify into 5 land cover types
landscape_low_autocorrelation <-
  nlm_mpd(1000, 1000, roughness = 0.2) %>%
  util_classify(weighting = c(0.1, 0.15, 0.4, 0.05, 0.3))

landscape_medium_autocorrelation <-
  nlm_mpd(1000, 1000, roughness = 0.6) %>%
  util_classify(weighting = c(0.1, 0.15, 0.4, 0.05, 0.3))

landscape_high_autocorrelation <-
  nlm_mpd(1000, 1000, roughness = 0.8) %>%
  util_classify(weighting = c(0.1, 0.15, 0.4, 0.05, 0.3))
