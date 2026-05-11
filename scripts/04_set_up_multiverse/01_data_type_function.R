library(tidyverse)
library(forcats)

############ DATA TYPE ############ 

# Four data types are taken into account:
# longitudinal w1: includes longitudinal data of all people that are in w1 and (at least one) other waves
# longitudinal nostrict: includes longitudinal data of all people in at least two waves (no strict baseline wave)
# cross sectional including only wave 1
# cross sectional across all waves

df_type_function <- function(df, data_type, w1) {
  
  # For the longitudinal dfs: count how many waves each person appears in (this has to be at least two)
  wave_counts <- df |>
    group_by(mergeid) |> # for each individual in the dataset
    summarise(n_waves = n_distinct(wave)) |> # calculate in how many waves this person participated
    filter(n_waves >= 2) # if they appear in the df 2 or more times, keep them in long_no_strict 
  
  # --- (DT) longitudinal w1
  # select only the people that are (at least) in w1 (baseline)
  if (data_type == "long_w1") {
    
    # keep people only if they occur at least twice AND if they occur in w1
    df <- df |> filter(mergeid %in% wave_counts$mergeid & mergeid %in% w1$mergeid)
  }
  
  # --- (DT) longitudinal no strict baseline
  # select the people that appear in at least two waves (as otherwise it is not longitudinal)
  # exclude people that only appear in w7 (as this would be cross-sectional and not longitudinal)
  else if (data_type == "long_nostrict") {
    
    # Now filter the full dataset for individuals that appear twice or more
    df <- df |> filter(mergeid %in% wave_counts$mergeid)
  }
  
  # --- (DT) cross-sectional wave 1
  else if (data_type == "cross_w1") {
    
    w1 <- w1 |> mutate(wave = "w1")
    df <- w1
    
  }
  # --- (DT) cross-sectional all waves
  # For this, the default df can be used.
  else {
    df <- df
  }
  
  return(df)
  
}
