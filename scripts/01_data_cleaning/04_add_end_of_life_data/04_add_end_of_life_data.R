library(foreign) # required to load SPSS data
library(tidyverse) # required for data wrangling
# install.packages("here")
library(here) # locate working directory

### LOAD END OF LIFE DATA ###
# Load Data End-of-Life w2
w2_xt_raw <- read.spss(here("data/rawdata/wave2/sharew2_rel9-0-0_xt.sav"), 
                       to.data.frame=TRUE)

# Load Data End-of-Life w4
w4_xt_raw <- read.spss(here("data/rawdata/wave4/sharew4_rel9-0-0_xt.sav"), 
                       to.data.frame=TRUE)

# Load Data End-of-Life w5
w5_xt_raw <- read.spss(here("data/rawdata/wave5/sharew5_rel9-0-0_xt.sav"), 
                       to.data.frame=TRUE)


# Load Data End-of-Life w6
w6_xt_raw <- read.spss(here("data/rawdata/wave6/sharew6_rel9-0-0_xt.sav"), 
                       to.data.frame=TRUE)


# Load Data End-of-Life w7
w7_xt_raw <- read.spss(here("data/rawdata/wave7/sharew7_rel9-0-0_xt.sav"), 
                       to.data.frame=TRUE)


### SELECT END OF LIFE VARIABLES ### 
# Combine end-of-life data from all waves that have it
xt_all <- bind_rows(
  w2_xt_raw |> select(mergeid, xt010_, xt011_),
  w4_xt_raw |> select(mergeid, xt010_, xt011_),
  w5_xt_raw |> select(mergeid, xt010_, xt011_),
  w6_xt_raw |> select(mergeid, xt010_, xt011_),
  w7_xt_raw |> select(mergeid, xt010_, xt011_)
)

### MERGE DATA FROM ALL WAVES TO JOIN END OF LIFE DATASETS ###
# Load Cleaned Data From All Waves
w1 <- readRDS(here("data/cleandata/w1_clean.RDS"))
w2 <- readRDS(here("data/cleandata/w2_clean.RDS"))
w4 <- readRDS(here("data/cleandata/w4_clean.RDS"))
w5 <- readRDS(here("data/cleandata/w5_clean.RDS"))
w6 <- readRDS(here("data/cleandata/w6_clean.RDS"))
w7 <- readRDS(here("data/cleandata/w7_clean.RDS"))

# First, combine all datasets into a default df
# And create a column that notes which data came from which wave
df <- bind_rows(                        
  w1 |> mutate(wave = "w1"),
  w2 |> mutate(wave = "w2"),
  w4 |> mutate(wave = "w4"),
  w5 |> mutate(wave = "w5"),
  w6 |> mutate(wave = "w6"),
  w7 |> mutate(wave = "w7")) |>
  select(mergeid, wave, everything())  # change column order to increase readability

# Then join cause of death onto this combined df
df_all_waves <- df |> left_join(xt_all, by = "mergeid")

# Make age of death numeric
df_all_waves$xt010_ <- as.numeric(as.character(df_all_waves$xt010_))

# Write RDS 
write_rds(df_all_waves, here("data/cleandata/df_all_waves.RDS"))
