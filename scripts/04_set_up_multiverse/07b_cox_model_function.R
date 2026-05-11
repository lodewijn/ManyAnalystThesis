library(tidyverse)
library(lme4)
library(stats)
library(geepack)
library(survival)
library(broom)
library(broom.mixed)


# The third step in running the multiverse analysis, is setting up the 
# statistical models (SM) and extracting the results.

############ COX STATISTICAL MODEL ############ 

# Six different model types are used:
# "cox_haz",         # cox proportional hazards
# "log_reg",         # logistic regression
# "log-binom",       # log-binomial model
# "mix_log_reg",     # mixed-effects logistic regression
# "time_mix",        # discrete time mixed effect model
# "GEE"              # generalized estimating equations

# This function focuses on cox only, becasue the formula and outcomes etc. are slightly
# different for this model than for the other five models.

cox_model_function <- function(formula, df) {
  
  # --- When one of the models does not converge, instead of crashing the whole multiverse
  # the results are set to NA
  tryCatch({
    
# --- (SM) Cox proportional hazards model
    model <- coxph(formula, data = df)
    
    # Extract relevant model results:
    # Estimate of exposure
    # Confidence interval
    # P-value
    
    res <- tidy(model, 
                conf.int = TRUE, 
                exponentiate = TRUE) # exponentiate all estimates to get HR
    
    # Select only exposure effect
    res <- res |> 
      filter(term == "exposure") |> 
      select(estimate, conf.low, conf.high, p.value)
    
    return(res)
    
  }, 
  
  error = function(e) {
    
    tibble(estimate = NA, conf.low = NA, conf.high = NA, p.value = NA)
    
  })
}
