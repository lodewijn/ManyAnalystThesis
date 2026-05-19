library(tidyverse)
library(forcats)

# The first step of running the multiverse analysis, is data preparation. 
# This consists of three decisions, namely missing data handling (MD), 
# choosing the data type (DT) and exclusion criteria (EC).

############ MISSING DATA ############ 

# FOR NOW: Two missing data handling methods are taken into account:
# No information: in all categorical variables, NAs are replaced by 'no information'
# to prevent extra information being lost
# Complete cases: only rows without NAs are taken into account

missingness_function <- function(df, missing_data) {
  
  # --- (MD) no information
  # replace NAs in categorical adjustment set variables by 'no information'
  if (missing_data == "ni") {
    
    df <- df |> 
      mutate(dn042_    = fct_na_value_to_level(dn042_,  level = "NoInfo"),  # sex
             country   = fct_na_value_to_level(country, level = "NoInfo"),  # country
             dn010_    = fct_na_value_to_level(dn010_,  level = "NoInfo"),  # education
             br001_    = fct_na_value_to_level(br001_, level = "NoInfo"),  # ever smoked daily
             phactiv   = fct_na_value_to_level(phactiv, level = "NoInfo")) |>  # physical activity
    
      drop_na(age_int) # because some models cannot handle NAs 
      # and there were only 20 NAs in age_int, it was decided to drop these rows
  
      }
  
  # dn018_ and dn019_ in these variables NAs are meaningful, because these are the years 
  # of widowing and divorce. Some people may have never been divorced, widowed, or even married. 
  # However, since these were only needed in 02_exclusion_function, 
  # missings in these columns do not matter for the next steps in the multiverse.
  
  # --- (MD) complete cases
  else {
    
    # Since a lot of data will get lost when just applying na.omit 
    # (for example because people who are still alive will likely have NA 
    # for the end-of-life variable), only the adjustment set variables, 
    # and exposure variable were used for the complete cases for now. 
    
    df <- df |> 
      
      drop_na(age_int, 
                        dn042_, 
                        country,
                        phactiv) |>
                      
    
      # Because these two variables are time invariant and only recorded in w1,
      # instead of listwise deleting all rows with NAs (which messes up the longitudinal
      # structure of the data), I decided to fill the missings in later waves with the 
      # value at w1 in the cc condition.
    
      group_by(mergeid) |>
      arrange(wave) |>
      fill(dn010_, .direction = "down") |> # education
      fill(br001_, .direction = "down") |> # ever smoked daily
      ungroup() |>
      
      # Since some of the participants may also have NAs at w1, we still need 
      # to drop the NAs that persist after filling in.
      drop_na(dn010_, 
      br001_) 
    
  }
  
  # Drop unused levels of all factors (to improve model convergence)
  df <- df |> mutate(across(where(is.factor), droplevels))
  
  return(df)
  }
