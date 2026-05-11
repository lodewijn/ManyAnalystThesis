library(tidyverse)
library(broom)

# Because in order to perform a decision sensitivity analysis, it is important
# that all results are of the same effect size (ES). Becasue both hazard ratios (HR)
# and odds ratios (OR) can be converted to risk ratios (RR), this effect size
# was used for the decision sensitivity analysis.


############ CONVERTING EFFECT SIZES ############ 


conversion_function_corr <- function(res, model_type) {
  
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
    
    # Based on VanderWeele (2020), converting HR to RR when prevalence
    # is estimated between 0.2 and 0.8
    # Although the prevalence is slightly lower (around 17%), because p0 can differ
    # per universe, it was decided that this conversion would be better.
    
    RR <- res |> mutate(
      estimate = (1 - 0.5^sqrt(estimate)) / (1 - 0.5^sqrt(1/estimate)),
      conf.low = (1 - 0.5^sqrt(conf.low)) / (1 - 0.5^sqrt(1/conf.low)),
      conf.high = (1 - 0.5^sqrt(conf.high)) / (1 - 0.5^sqrt(1/conf.high))
    )
    
  }    

# --- (ES) Risk Ratio
else {
  
  # when model_type = log-binom the effect size is already a RR
  RR <- res
  
}

return(RR)
}
