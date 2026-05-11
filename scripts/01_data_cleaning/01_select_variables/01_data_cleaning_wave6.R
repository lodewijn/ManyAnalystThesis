# Data Preprocessing Wave 6
  
## Load Required Pacakges

library(foreign) # required to load SPSS data
library(tidyverse) # required for data wrangling
# install.packages("here")
library(here) # locate working directory

## Wave 6 - Load Data From SPSS Files
# Physical Health
w6_ph_raw <- read.spss(here("data/rawdata/wave6/sharew6_rel9-0-0_ph.sav"), to.data.frame=TRUE)

# Demographics
w6_dn_raw <- read.spss(here("data/rawdata/wave6/sharew6_rel9-0-0_dn.sav"), to.data.frame=TRUE)

# Behavioural Risks
w6_br_raw <- read.spss(here("data/rawdata/wave6/sharew6_rel9-0-0_br.sav"), to.data.frame=TRUE)

# General Health
w6_health_raw <- read.spss(here("data/rawdata/wave6/sharew6_rel9-0-0_gv_health.sav"), to.data.frame=TRUE)

# Age at time of interview
w6_age <- read.spss(here("data/rawdata/wave6/sharew6_rel9-0-0_cv_r.sav"), 
                    to.data.frame=TRUE)

## Select only the relevant variables for this study

# Physical Health
w6_ph <- w6_ph_raw |>
  select(mergeid,          # respondent ID
         ph006d1,          # heart attack ever
         ph006d4,          # stroke ever
         ph009_1,          # age heart attack
         ph009_4,          # age stroke
         #ph067_1,         # doesn't exist
         #ph067_2,         # doesn't exist
         ph072_1,          # heart attack since last interview
         ph072_2)          # stroke since last interview

# Demographics
w6_dn <- w6_dn_raw |>
  select(mergeid,          # respondent ID
         dn014_,           # marital status
         dn003_,           # birth year
         dn010_,           # education
         dn042_,           # sex
         country,          # country 
         dn015_,           # year of cohabiting marriage
         dn018_,           # since when divorced
         dn019_            # since when widowed
  )

# Behavioural risks
w6_br <- w6_br_raw |>
  select(mergeid,          # respondent ID
         br001_,           # ever smoked daily
         br002_)           # smoke at present time

# General health
w6_health <- w6_health_raw |>
  select(mergeid,          # respondent ID
         phactiv)          # physical activity

# Age at interview
w6_age <- w6_age |>
  select(mergeid,          # respondent ID
         age_int,          # age at interview
         age2015)          # age in 2015

# Merge all datasets of Wave 6 together using mergeid
w6 <- w6_ph %>%
  left_join(w6_dn, by = "mergeid") |>
  left_join(w6_br, by = "mergeid") |>
  left_join(w6_health, by = "mergeid") |>
  left_join(w6_age, by = "mergeid")


# Write RDS file containing the selected data from Wave 6
write_rds(w6, here("data/cleandata/w6_clean.RDS"))

