library(tidyverse)

############ ADJUSTMENT SET / FORMULA ############ 

# In the decision space, all variables needed for different adjustment sets
# (already containing the name in the original df) were combined and + separated,
# except the "none" variable, which just contains an empty set of confounders,
# so all we need to set up the formula is the adjustment_label.



# Select the exposure and outcome column that were just created in df
# And add the adjustment set column from the decision space
formula_function <- function(outcome = "outcome", 
                             exposure = "exposure",
                             adjustment_label) {
  
# --- (AS) All other models + Empty set  
# else  
   if (adjustment_label == "none") {
      
      formula(paste(outcome, "~", exposure))
   }
# --- (AS) All other combinations
  else {
    
    formula(paste(outcome, "~", exposure, "+", adjustment_label))
  }
}
