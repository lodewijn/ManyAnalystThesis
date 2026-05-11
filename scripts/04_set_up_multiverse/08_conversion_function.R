library(tidyverse)
library(broom)

# Because in order to perform a decision sensitivity analysis, it is important
# that all results are of the same effect size (ES). Becasue both hazard ratios (HR)
# and odds ratios (OR) can be converted to risk ratios (RR), this effect size
# was used for the decision sensitivity analysis.


############ CONVERTING EFFECT SIZES ############ 


conversion_function <- function(res, model_type) {
  
# --- (ES) Odds Ratio
  if (model_type %in% c("log_reg", "mix_log_reg", "GEE", "time_mix")) {
    
    # Based on VanderWeele (2020), converting OR to RR when the prevalence
    # rate in the unexposed group (p0) is unknown but higher than 10%, can be
    # done by taking the square root of the OR
    
    RR <- res |> mutate(
        estimate = sqrt(estimate),
        conf.low = sqrt(conf.low),
        conf.high = sqrt(conf.high)
      
    )
    
  }

# --- (ES) Hazard Ratio
  
  else if (model_type == "cox_haz"){
    
    # WRONG
    
    RR <- res
    
  }
  
# --- (ES) Risk Ratio
  else {
    
    # when model_type = log-binom the effect size is already a RR
    RR <- res
    
  }
  
  return(RR)
}
