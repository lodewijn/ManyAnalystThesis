# Data Preprocessing Wave 2

## Load Required Pacakges
library(foreign) # required to load SPSS data
library(tidyverse) # required for data wrangling
# install.packages("here")
library(here) # locate working directory

## Wave 2 - Load Data From SPSS Files
# Physical Health
w2_ph_raw <- read.spss(here("data/rawdata/wave2/sharew2_rel9-0-0_ph.sav"), 
                       to.data.frame=TRUE)

# Demographics
w2_dn_raw <- read.spss(here("data/rawdata/wave2/sharew2_rel9-0-0_dn.sav"), 
                       to.data.frame=TRUE)

# Behavioural Risks
w2_br_raw <- read.spss(here("data/rawdata/wave2/sharew2_rel9-0-0_br.sav"), 
                       to.data.frame=TRUE)

# General Health
w2_health_raw <- read.spss(here("data/rawdata/wave2/sharew2_rel9-0-0_gv_health.sav"), 
                           to.data.frame=TRUE)
# Age at time of interview
w2_age <- read.spss(here("data/rawdata/wave2/sharew2_rel9-0-0_cv_r.sav"), 
                    to.data.frame=TRUE)

## Select only the relevant variables for this study
# Physical Health
w2_ph <- w2_ph_raw |>
  select(mergeid,               # respondent ID
         ph006d1,               # heart attack ever
         ph006d4,               # stroke ever
         ph009_1,               # age heart attack
         ph009_4,               # age stroke
         ph067_1,               # heart attack since last interview
         ph067_2,               # stroke recent since last interview
         ph068_1,               # heart attack before last interview
         ph068_2)  |>           # stroke before last interview
  mutate(ph072_1 = ph068_1,     # rename variable to match w4-w7
         ph072_2 = ph068_2) |>  # rename variable to match w4-w7
  select(-ph068_2, -ph068_1)

# Demographics
w2_dn <- w2_dn_raw |>
  select(mergeid,            # respondent ID
         dn014_,             # marital status
         dn003_,             # birth year
         dn010_,             # education
         dn042_,             # sex
         country,            # country 
         dn015_,             # year of cohabiting marriage
         dn018_,             # since when divorced
         dn019_              # since when widowed
  )

# Behavioural risks
w2_br <- w2_br_raw |>
  select(mergeid,            # respondent ID
         br001_,             # ever smoked daily
         br002_)            # smoke at present time

# General health
w2_health <- w2_health_raw |>
  select(mergeid,            # respondent ID
         phactiv)            # physical activity

# Age at interview
w2_age <- w2_age |>
  select(mergeid,          # respondent ID
         age_int,          # age at interview
         age2007)          # age in 2007 

# Merge all datasets of Wave 2 together using mergeid
w2 <- w2_ph %>%
  left_join(w2_dn, by = "mergeid") |>
  left_join(w2_br, by = "mergeid") |>
  left_join(w2_health, by = "mergeid") |>
  left_join(w2_age, by = "mergeid") 

# Write RDS file containing the selected data from Wave 2
write_rds(w2, here("data/cleandata/w2_clean.RDS"))
