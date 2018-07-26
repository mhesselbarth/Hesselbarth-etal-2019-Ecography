
#### 1. Source functions #### 
purrr::walk(list.files(path = "1_Setup", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

purrr::walk(list.files(path = "2_Functions", pattern = ".R", full.names = TRUE), 
            function(x) source(x))

#### 2. Import landscapes #### 

# Low AC
landscapes_low_ac <- read_rds(paste0(getwd(), 
                                     "/4_Results/landscapes_low_ac.rds"))

# Medium AC
landscapes_medium_ac <- read_rds(paste0(getwd(), 
                                     "/4_Results/landscapes_medium_ac.rds"))

# High AC
landscapes_high_ac <- read_rds(paste0(getwd(), 
                                     "/4_Results/landscapes_high_ac.rds"))
                                  

#### 3. Calculate "real" values ####

future::plan(future::multiprocess)

# Low AC
true_value_low_ac <- calculate_metrics(landscapes_low_ac, 
                                       what = c("class", "landscape"))

# Medium AC
true_value_medium_ac <- calculate_metrics(landscapes_medium_ac, 
                                       what = c("class", "landscape"))

# High AC
true_value_high_ac <- calculate_metrics(landscapes_high_ac, 
                                       what = c("class", "landscape"))


#### 4. Save results ####

# Low AC
UtilityFunctions::Save.Function.rds(object = true_value_low_ac, 
                                    filename = "true_value_low_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"), 
                                    overwrite = FALSE)

# Medium AC
UtilityFunctions::Save.Function.rds(object = true_value_medium_ac, 
                                    filename = "true_value_medium_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"), 
                                    overwrite = FALSE)

# High AC
UtilityFunctions::Save.Function.rds(object = true_value_high_ac, 
                                    filename = "true_value_high_ac.rds", 
                                    path = paste0(getwd(), "/4_Results"), 
                                    overwrite = FALSE)



