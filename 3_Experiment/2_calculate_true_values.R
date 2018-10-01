
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

# future::plan(future::multiprocess)

# Low AC
true_value_low_ac_class <- landscapemetrics::calculate_lsm(landscapes_low_ac, 
                                       what = "class", progress = TRUE)
true_value_low_ac_landscape <- landscapemetrics::calculate_lsm(landscapes_low_ac, 
                                             what = "landscape", progress = TRUE)

# Medium AC
true_value_medium_ac_class <- landscapemetrics::calculate_lsm(landscapes_medium_ac, 
                                             what = "class", progress = TRUE)
true_value_medium_ac_landscape <- landscapemetrics::calculate_lsm(landscapes_medium_ac, 
                                                 what = "landscape", progress = TRUE)

# High AC
true_value_high_ac_class <- landscapemetrics::calculate_lsm(landscapes_high_ac, 
                                             what = "class", progress = TRUE)
true_value_high_ac_landscape <- landscapemetrics::calculate_lsm(landscapes_high_ac, 
                                                 what = "landscape", progress = TRUE)


#### 4. Save results ####

overwrite <- FALSE

# Low AC
UtilityFunctions::save_rds(object = true_value_low_ac_class,
                           filename = "true_value_low_ac_class.rds", 
                           path = paste0(getwd(), "/4_Results"), 
                           overwrite = overwrite)

UtilityFunctions::save_rds(object = true_value_low_ac_landscape,
                           filename = "true_value_low_ac_landscape.rds", 
                           path = paste0(getwd(), "/4_Results"), 
                           overwrite = overwrite)

# Medium AC
UtilityFunctions::save_rds(object = true_value_medium_ac_class,
                           filename = "true_value_medium_ac_class.rds", 
                           path = paste0(getwd(), "/4_Results"), 
                           overwrite = overwrite)

UtilityFunctions::save_rds(object = true_value_medium_ac_landscape,
                           filename = "true_value_medium_ac_landscape.rds", 
                           path = paste0(getwd(), "/4_Results"), 
                           overwrite = overwrite)

# High AC
UtilityFunctions::save_rds(object = true_value_high_ac_class,
                           filename = "true_value_high_ac_class.rds", 
                           path = paste0(getwd(), "/4_Results"), 
                           overwrite = overwrite)

UtilityFunctions::save_rds(object = true_value_high_ac_landscape,
                           filename = "true_value_high_ac_landscape.rds", 
                           path = paste0(getwd(), "/4_Results"), 
                           overwrite = overwrite)



