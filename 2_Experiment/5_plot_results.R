
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

simulation_design$id <- rep(1:(nrow(simulation_design)/25), times = 25)

#### 2. Import results #### 

# Low AC
deviation_low_ac <- read_rds(paste0(getwd(), 
                                    "/3_Output/deviation_low_ac_25.rds"))

# Medium AC
deviation_medium_ac <- read_rds(paste0(getwd(), 
                                       "/3_Output/deviation_medium_ac_25.rds"))

# High AC
deviation_high_ac <- read_rds(paste0(getwd(), 
                                     "/3_Output/deviation_high_ac_25.rds"))

#### 3. Plot results ####

# Low AC
plot_heatmap(deviation_low_ac, simulation_design)


# Medium AC
plot_heatmap(deviation_medium_ac, simulation_design)


# High AC
plot_heatmap(deviation_high_ac, simulation_design)
