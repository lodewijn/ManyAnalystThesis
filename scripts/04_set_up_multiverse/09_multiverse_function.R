# Multiverse function

# To run the multiverse, all previously written functions are sourced,
# while looping over the rows of the decision space, while adding extra
# columns to the decision space containing the estimated results of each universe.

multiverse_function_draft <- function(df, decision_space, w1) {
  
  # Add progression bar
  pb <- txtProgressBar(min = 0, max = nrow(decision_space), style = 3)
  
  # Run all functions, one universe (row) at a time
  for(i in 1:nrow(decision_space)){
    
  # Start progression bar
    setTxtProgressBar(pb, i)
    
  # Select one universe at a time
    universe <- decision_space[i, ]
    
  # Create the data frame to be used in the statistical models
    # --- (DT)
    df_subset <- df_type_function(df = df, 
                                  data_type = universe$data_type, 
                                  w1 = w1)
    
    # --- (EC)
    df_subset <- exclusion_function(df = df_subset, 
                                    exclusion = universe$exclusion)
    
    # --- (EX)
    df_subset <- exposure_function(df = df_subset)
    
    # --- (OUT)
    df_subset <- outcome_function(df = df_subset, 
                                  outcome_label = universe$outcome_label)
    
    # --- (MD)
    df_subset <- missingness_function(df_subset, universe$missing_data) 

  # Create formula and apply model and RR conversion
    # --- (AS)
    formula <- adjustment_function(outcome = "outcome", 
                                   exposure = "exposure", 
                                   adjustment_label = universe$adjustment_label)
    
    # --- (SM)
    res <- model_function(formula = formula, 
                          df = df_subset, 
                          model_type = universe$model_type)
    
    # --- (ES)
    RR <- conversion_function(res = res, 
                              model_type = universe$model_type)
    
  # Store results by adding extra results columns in the decision space
    decision_space$RR[i] <- RR$estimate
    decision_space$conf.low[i] <- RR$conf.low
    decision_space$conf.high[i] <- RR$conf.high
    decision_space$p.value[i] <- RR$p.value
    
  }
  
  decision_space
  
}
