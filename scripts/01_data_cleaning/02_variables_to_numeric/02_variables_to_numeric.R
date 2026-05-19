# Convert_time_variables_to_numeric_all_waves

# Load Required Packages

library(tidyverse)
library(here)

# Load Cleaned Data From All Waves
w1 <- readRDS(here("data/cleandata/w1_clean.RDS"))
w2 <- readRDS(here("data/cleandata/w2_clean.RDS"))
w4 <- readRDS(here("data/cleandata/w4_clean.RDS"))
w5 <- readRDS(here("data/cleandata/w5_clean.RDS"))
w6 <- readRDS(here("data/cleandata/w6_clean.RDS"))
w7 <- readRDS(here("data/cleandata/w7_clean.RDS"))

# Covert age variables to numeric per wave
# And make sure all waves can be merged at a later stage

w1 <- w1 |>
  mutate(age_wave = as.numeric(as.character(age2004))) |>
  select(-age2004)

w2 <- w2 |> 
  mutate(age_wave = as.numeric(as.character(age2007))) |>
  select(-age2007)
  
w4 <- w4 |> 
  mutate(age_wave = as.numeric(as.character(age2011))) |>
  select(-age2011)

w5 <- w5 |> 
  mutate(age_wave = as.numeric(as.character(age2013))) |>
  select(-age2013)

w6 <- w6 |> 
  mutate(age_wave = as.numeric(as.character(age2015))) |>
  select(-age2015)

w7 <- w7 |> 
  mutate(age_wave = as.numeric(as.character(age2017))) |>
  select(-age2017)

# Convert all age and year variables to numeric
# Put all data frames in a list to mutate them all at once
waves <- list(w1 = w1, w2 = w2, w4 = w4, w5 = w5, w6 = w6, w7 = w7)

# Convert the variables to numeric
waves <- lapply(waves, \(df) {
  df |>
    mutate(age_int = as.numeric(as.character(age_int)), # age at interview
           dn003_ = as.numeric(as.character(dn003_)), # year of birth
           ph009_1 = as.numeric(as.character(ph009_1)), # age heart attack
           ph009_4 = as.numeric(as.character(ph009_4)), # age stroke
           dn015_ = as.numeric(as.character(dn015_)), # year marriage
           dn018_ = as.numeric(as.character(dn018_)), # year divorce
           dn019_ = as.numeric(as.character(dn019_))) # year widowed
})

# Unpack back into original objects
w1 <- waves$w1
w2 <- waves$w2
w4 <- waves$w4
w5 <- waves$w5
w6 <- waves$w6
w7 <- waves$w7

# Check if adjustment set variables are factors where needed (they are for all waves)
#str(w1$dn002_)          # birth month
#str(w1$dn042_)          # sex
#str(w1$country)         # country
#str(w1$dn010_)          # education
#str(w1$br002_)          # smoke at present time
#str(w7$phactiv)         # physical activity

# Update the RDS files containing the clean data from all waves
write_rds(w1, here("data/cleandata/w1_clean.RDS"))
write_rds(w2, here("data/cleandata/w2_clean.RDS"))
write_rds(w4, here("data/cleandata/w4_clean.RDS"))
write_rds(w5, here("data/cleandata/w5_clean.RDS"))
write_rds(w6, here("data/cleandata/w6_clean.RDS"))
write_rds(w7, here("data/cleandata/w7_clean.RDS"))


