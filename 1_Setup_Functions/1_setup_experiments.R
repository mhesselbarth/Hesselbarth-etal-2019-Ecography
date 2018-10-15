
#### 1. Load packages ####
check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages <- c(
  "clustermq",
  "dplyr", 
  "ggplot2",
  "landscapemetrics",
  "landscapetools",
  "maptools", 
  "NLMR",
  "purrr",
  "raster",
  "readr",
  "sp", 
  "tidyr",
  "hrbrthemes"
  )

check.packages(packages)

#### 2. Set experiment settings ####
size <- c(2500, 7500, 20000) # plot size
n <- c(1, 2, 3) # number of plots
shape <- c("circle", "square", "rectangle") # plot shape
type <- c("random", "regular") # sample desing
simulation_run <- seq(5, 125, 5)

simulation_design <- tibble::as.tibble(expand.grid(size = size, 
                                                   n = n, 
                                                   shape = shape, 
                                                   type = type, 
                                                   i = seq_along(simulation_run), 
                                                   stringsAsFactors = FALSE))


# We want to sample 10% (25000), 35%(87500), 75% (187500) of the cells for each 
# size -> therefore the number of plots is different
simulation_design <- dplyr::mutate(simulation_design,
                                   n = dplyr::case_when(size == 2500 & n == 1 ~ 10,
                                                        size == 2500 & n == 2 ~ 35,
                                                        size == 2500 & n == 3 ~ 75,
                                                        size == 7500 & n == 1 ~ 4,
                                                        size == 7500 & n == 2 ~ 12,
                                                        size == 7500 & n == 3 ~ 25, 
                                                        size == 20000 & n == 1 ~ 2,
                                                        size == 20000 & n == 2 ~ 5,
                                                        size == 20000 & n == 3 ~ 10))

rm(packages, check.packages,
   size, n, shape, type)