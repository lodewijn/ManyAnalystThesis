multiverse_function_parallel <- function(df, decision_space, w1) {
  
  library(foreach)
  library(doFuture)
  library(future)
  library(progressr)
  
  # Set up parallel processing
  registerDoFuture()
  plan(multisession, workers = parallel::detectCores())
  handlers(global = TRUE)
  
  # Run in parallel
  results <- with_progress({
    
    p <- progressor(nrow(decision_space))
    
    foreach(i = 1:nrow(decision_space),
            .combine = rbind,
            .packages = c("tidyverse", "broom", "broom.mixed", "lme4", "geepack")) %dopar% {
              
              p()
              
              universe <- decision_space[i, ]
              
              tryCatch({
                df_subset <- df_type_function(df = df, data_type = universe$data_type, w1 = w1)
                df_subset <- exclusion_function(df = df_subset, exclusion = universe$exclusion)
                df_subset <- exposure_function(df = df_subset)
                df_subset <- outcome_function(df = df_subset, outcome_label = universe$outcome_label)
                df_subset <- missingness_function(df_subset, universe$missing_data) 
                
                frm <- formula_function(outcome = "outcome", exposure = "exposure",
                                        model_type = universe$model_type,
                                        adjustment_label = universe$adjustment_label)
                
                res <- model_function(formula = frm, df = df_subset, model_type = universe$model_type)
                RR <- conversion_function(res = res, model_type = universe$model_type)
                
                # Store results by adding extra results columns in the decision space
                decision_space$RR[i] <- RR$estimate
                decision_space$conf.low[i] <- RR$conf.low
                decision_space$conf.high[i] <- RR$conf.high
                decision_space$p.value[i] <- RR$p.value
                decision_space
                
              }, error = function(e) {
                decision_space$RR[i] <- NA
                decision_space$conf.low[i] <- NA
                decision_space$conf.high[i] <- NA
                decision_space$p.value[i] <- NA
                decision_space
              })
            }
  })
  
  # Reset to sequential
  plan(sequential)
  
  results
}
