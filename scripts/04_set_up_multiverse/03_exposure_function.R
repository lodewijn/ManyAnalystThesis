library(tidyverse)

# The second step in running the multiverse analysis, is selecting the 
# exposure (EX) and outcome (OUT) variables and adjustment set (AS)
# and setting up the formulas that can be used in the statistical models.

############ EXPOSURE ############ 

# In all analyses, the exposure variable is whether participants are married and
# living together which is classified as 1. All other options are classified as 0.

exposure_function <- function(df) {
  
  df <- df |> 
    
    group_by(mergeid) |>
    arrange(wave) |>
    fill(dn014_, .direction = "down") |> # this was often only asked in w1
    
    mutate(exposure = ifelse(dn014_ == "Married and living together with spouse", 1, 0),
           
    # When no exposure was recorded (either not married, married but not living 
    # together, or other) even when it was NA, 0 was used. 
    # This makes the assumption that not asked = not exposed.
    exposure = replace_na(exposure, 0)) |>
    ungroup()
  
  return(df)
}