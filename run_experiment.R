set.seed(42)

# source simulation function
source("1_Setup/1_load_packages.R")
source("2_Simulate_NLM/simulate_nlm.R")
source("3_Sampling_Functions/sample_circles.R")
source("3_Sampling_Functions/sample_squares.R")

# 1. Create simulation design

size <- c(100, 1250, 7500)
n <- c(10,25,50)
type <- c("random", "regular")

sim_design <- expand.grid(size, n, type)

seed <- seq(5,50, 5)
# 2. 

library(furrr)
future_map(seed, function(seed) {
  ls_low_autocor <- landscape_low_autocorrelation(15)
  future_map(seq_len(nrow(sim_design)), function(row_simdesign) {
    sample_circles(ls_low_autocor,
                   size = sim_design[row_simdesign, 1],
                   type = sim_design[row_simdesign, 3],
                   n    = sim_design[row_simdesign, 2])
  })
})

