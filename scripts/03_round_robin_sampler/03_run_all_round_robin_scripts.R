library(here)
library(tidyverse)
library(readr)

# Load the decision space
decision_space <- read_csv(here("data/decision_space/decision_space.csv"))

# Load the universe row number function
source(here("scripts/03_round_robin_sampler/01_universe_rownr_function.R"))

# Use the function to create an object containing all row numbers per decision option
# of the decision space of interest
universe_rownumbers <- universe_rownumbers_function(decision_space)

# Load the Round Robin sampler function
source(here("scripts/03_round_robin_sampler/02_round_robin_sampler_function.R"))

# To get the sampled univeres, run the Round Robin function on the desired decision space, 
# with the desired number of universes per decision
universes_100 <- round_robin_sampler(decision_space, 
                                 universe_rownumbers, 
                                 n_per_option = 100, 
                                 seed = 260722)

# Go back from rownumbers to the actual universe with decisions and options
sampled_universes_100 <- decision_space[c(universes_100),]

# Write RDS with the sampled universes
write_rds(sampled_universes_100, here("data/sampled_universes/sampled_universes_100_", Sys.Date(), ".RDS"))