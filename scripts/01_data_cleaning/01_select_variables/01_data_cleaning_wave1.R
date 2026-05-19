# Data Preprocessing Wave 1

## Load Required Pacakges

library(foreign) # required to load SPSS data
library(tidyverse) # required for data wrangling
# install.packages("here")
library(here) # locate working directory

## Wave 1 - Load Data From SPSS Files
# Physical Health
w1_ph_raw <- read.spss(here("data/rawdata/wave1/sharew1_rel9-0-0_ph.sav"), 
                       to.data.frame=TRUE)

# Demographics
w1_dn_raw <- read.spss(here("data/rawdata/wave1/sharew1_rel9-0-0_dn.sav"), 
                       to.data.frame=TRUE)

# Behavioural Risks
w1_br_raw <- read.spss(here("data/rawdata/wave1/sharew1_rel9-0-0_br.sav"), 
                       to.data.frame=TRUE)

# General Health
w1_health_raw <- read.spss(here("data/rawdata/wave1/sharew1_rel9-0-0_gv_health.sav"), 
                           to.data.frame=TRUE)

# Age at time of interview
w1_age <- read.spss(here("data/rawdata/wave1/sharew1_rel9-0-0_cv_r.sav"), 
                           to.data.frame=TRUE)


## Select only the relevant variables for this study

# Physical Health
w1_ph <- w1_ph_raw |>
  select(mergeid,          # respondent ID
         ph006d1,          # heart attack ever
         ph006d4,          # stroke ever
         ph009_1,          # age heart attack
         ph009_4)          # age stroke

# Demographics
w1_dn <- w1_dn_raw |>
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

# Behavioural Risks
w1_br <- w1_br_raw |>
  select(mergeid,          # respondent ID
         br001_,           # ever smoked daily
         br002_)           # smoke at present time
           
# General Health
w1_health <- w1_health_raw |>
  select(mergeid,          # respondent ID
         phactiv)          # physical activity

# Age at interview
w1_age <- w1_age |>
  select(mergeid,          # respondent ID
         age_int,          # age at interview
         age2004)          # age in 2004 
               

# Merge all datasets of Wave 1 together using mergeid
w1 <- w1_ph |>
  left_join(w1_dn, by = "mergeid") |>
  left_join(w1_br, by = "mergeid") |> 
  left_join(w1_health, by = "mergeid") |>
  left_join(w1_age, by = "mergeid")


# Write RDS file containing the selected data from Wave 1
write_rds(w1, here("data/cleandata/w1_clean.RDS"))



