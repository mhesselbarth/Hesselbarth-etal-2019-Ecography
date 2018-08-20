
#### 1. Load packages ####

check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages<-c("furrr", 
            "landscapemetrics",
            "landscapetools",
            "magrittr", 
            "maptools", 
            "NLMR",
            "raster",
            "rgeos",
            "sp",
            "tidyverse"
            )

check.packages(packages)

#### 2. Set experiment settings ####

simulation_run <- seq(5, 50, 5) #seq(5,50, 5)

size <- c(100, 1250, 7500) # plot size
n <- c(10, 25, 50) # number of plots
shape <- c("circle", "square", "rectangle") # plot shape
type <- c("random", "regular") # sample desing

simulation_design <- expand.grid(size = size, 
                                 n = n, 
                                 shape = shape, 
                                 type = type) %>%
  tibble::as.tibble()

rm(packages, check.packages,
   size, n, shape, type)

set.seed(42)
