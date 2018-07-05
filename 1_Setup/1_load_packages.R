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
