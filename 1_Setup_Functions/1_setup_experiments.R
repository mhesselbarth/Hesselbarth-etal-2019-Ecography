
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
  "landscapemetrics",
  "landscapetools",
  "maptools", 
  "NLMR",
  "purrr",
  "raster",
  "readr",
  "sp"
  )

check.packages(packages)

#### 2. Set experiment settings ####
size <- c(100, 1250, 7500) # plot size
n <- c(10, 25, 50) # number of plots
shape <- c("circle", "square", "rectangle") # plot shape
type <- c("random", "regular") # sample desing
simulation_run <- seq(5, 50, 5)


simulation_design <- tibble::as.tibble(expand.grid(size = size, 
                                                   n = n, 
                                                   shape = shape, 
                                                   type = type, 
                                                   i = seq_along(simulation_run)))

rm(packages, check.packages,
   size, n, shape, type)