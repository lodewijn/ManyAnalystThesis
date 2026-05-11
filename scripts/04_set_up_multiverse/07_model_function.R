library(tidyverse)
library(lme4)
library(stats)
library(geepack)
library(survival)
library(broom)
library(broom.mixed)


# The third step in running the multiverse analysis, is setting up the 
# statistical models (SM) and extracting the results.

############ STATISTICAL MODELS ############ 

# Six different model types are used:
    # "cox_haz",         # cox proportional hazards
    # "log_reg",         # logistic regression
    # "log-binom",       # log-binomial model
    # "mix_log_reg",     # mixed-effects logistic regression
    # "time_mix",        # discrete time mixed effect model
    # "GEE"              # generalized estimating equations

model_function <- function(formula, df, model_type) {

  tryCatch({
    
# --- (SM) Logistic regression
  if (model_type == "log_reg") {
    
    model <- glm(formula, data = df, family = binomial(link = "logit"))
    
  }
  
# --- (SM) Log-binomial model
  else if (model_type == "log-binom") {
    
    model <- glm(formula, data = df, family = binomial(link = "log"))
    
  }
  
# --- (SM) Mixed-effects logistic regression
    else if (model_type == "mix_log_reg") {
    
    model <- glmer(update(formula, . ~ . + (1 | mergeid)), 
                   data = df, 
                   family = binomial(link = "logit"), 
                   control = glmerControl(optCtrl = list(maxfun = 10000)),
                   nAGQ = 0)

    }
    
# --- (SM) Generalized estimating equations
    else if (model_type == "GEE") {
    
    # The waves variable needs to be numeric
    df <- df |> 
      mutate(wave_num = as.numeric(gsub("w", "", wave)),
             mergeid = as.factor(mergeid)) |>
      arrange(mergeid)
    
    # Fit the GEE model
    model <- geeglm(formula, 
                    waves = wave_num, 
                    id = mergeid, 
                    data = df, 
                    family = binomial(link = "logit"), 
                    corstr = "exchangeable")
    
    }
    
# --- (SM) Discrete time mixed effect model
    else if (model_type == "time_mix") {
    
      
    # In discrete time mixed effect models, time is modeled as a categorical factor.
    # This means the wave variable should be used as a predictor in the mixed effect model.
    model <- glmer(update(formula, . ~ . + factor(wave) + (1 | mergeid)), 
                   data = df, 
                   family = binomial(link = "logit"), 
                   control = glmerControl(optCtrl = list(maxfun = 10000)), 
                   nAGQ = 0)
    
    }
    
# --- When one of the models does not converge, instead of crashing the whole multiverse
    # the results are set to NA
    
    else {
      
      return(tibble(estimate = NA, conf.low = NA, conf.high = NA, p.value = NA))
      
    }
    
    # Extract relevant model results:
    # Estimate of exposure
    # Confidence interval
    # P-value
    
    res <- tidy(model, 
                conf.int = TRUE, 
                exponentiate = TRUE) # exponentiate all estimates to get OR/RR/HR
    
    # Since we are only interested in the main effect of the exposure on the outcome
    # (as this is the only effect present in all universes) we only select this
    
    res <- res |> 
      filter(term == "exposure") |> 
      select(estimate, conf.low, conf.high, p.value)
    
  }, 
  
  error = function(e) {
    
    tibble(estimate = NA, conf.low = NA, conf.high = NA, p.value = NA)
    
  })
}
  
