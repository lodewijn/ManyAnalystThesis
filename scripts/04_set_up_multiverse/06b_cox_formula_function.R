library(tidyverse)
library(survival)

############ COX ADJUSTMENT SET / FORMULA ############ 

# In the decision space, all variables needed for different adjustment sets
# (already containing the name in the original df) were combined and + separated,
# except the "none" variable, which just contains an empty set of confounders,
# so all we need to set up the formula is the adjustment_label.

# Select the exposure and outcome column that were just created in df
# And add the adjustment set column from the decision space
cox_formula_function <- function(exposure = "exposure",
                                 adjustment_label) {
  
# --- (AS) Formula for Cox proportional hazards + Empty Set
  if (adjustment_label == "none") {
    
    formula(paste("Surv(age_first_wave, exit_age, outcome) ~", exposure))
  
    }
  
# --- (AS) Formula for Cox proportional hazards + Adjustment Set
   else {
     
     formula(paste("Surv(age_first_wave, exit_age, outcome) ~", exposure, "+", adjustment_label))
     
    }
 
}
