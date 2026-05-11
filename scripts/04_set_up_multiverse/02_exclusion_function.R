library(tidyverse)
library(forcats)

############ EXCLUSION CRITERIA ############ 

# Six exclusion criteria are used
    # People married before 18 years old (dn015_)
    # Change in exposure - people that are either divorced (dn018_) or widowed (dn019_)
    # People from Israel (country)
    # People younger than 55 at w1 (Year of birth: dn003_)
    # People born after 1954 (Year of birth: dn003_)  
    # No exclusion


exclusion_function <- function(df, exclusion) {

# --- (EC) People married before 18 years old (dn015_)
  if (exclusion == "married_before18") {

    # People that are married after 18 or have NA in either marriage/birth year are kept in the df
    df |> filter(df$dn015_ - df$dn003_ >= 18 # keeps only people married after they were 18 years old
                 | is.na(dn015_)   # keeps people that have an NA on year of marriage (if they were never married)
                 | is.na(dn003_))  # keeps people that have NA for birth year
    }
  
# --- (EC) Change in exposure - people that are either divorced (dn018_) or widowed (dn019_)
  else if (exclusion == "divorced_widowed") {
    
    # The people that had a change in exposure (either divorced or widowed) are the only ones who do not have NAs in these columns
    # So filter for people that have NA in either of these columns
    df |> filter(is.na(dn018_) |  # NA on divorced
                   is.na(dn019_)) # NA on widowed
  }
  
# --- (EC) People from Israel (country)
  else if (exclusion == "country") {
    
    # Exclude only the people from Israel
    df |> filter(country != "Israel")
  }
  
# --- (EC) People younger than 55 at w1 (Year of birth: dn003_)
  else if (exclusion == "younger_than_55_w1") {
    
    # Wave 1 was collected in 2004, so participants older than 55 in 2004 are kept
    df |> filter(2004 - dn003_ >= 55 | 
                   is.na(dn003_)) # or if they have NAs for birth year
  }
  
# --- (EC) People born after 1954 (Year of birth: dn003_)  
  else if (exclusion == "born_after1954") {
    
    # Keep only people born before 1954
    df |> filter(dn003_ <= 1954 | 
                   is.na(dn003_)) # or if they have NAs for birth year
  }
  
# --- (EC) No exclusion 
  else {
    df
  }
  
}
