library(foreach)
library(doFuture)
library(future)
library(here)

multiverse_function_parallel_intermediate <- function(df, decision_space, w1, subset_size) {
  
  registerDoFuture()
  plan(multisession, workers = parallel::detectCores() - 2)
  
  n <- nrow(decision_space)
  subset <- subset_size
  all_results <- list()
  
  for (sub_start in seq(1, n, by = subset)) {
    
    sub_end <- min(sub_start + subset - 1, n)
    cat("Processing subset", sub_start, "to", sub_end, "out of", n, "universes", "\n")
    
    subset_results <- foreach(i = sub_start:sub_end,
                              .combine = rbind,
                              .export = c("w1", "df", "df_type_function", "exclusion_function",
                                          "exposure_function", "outcome_function", "formula_function",
                                          "model_function", "conversion_function", "missingness_function"),
                              .packages = c("tidyverse", "broom", "broom.mixed", "lme4", "geepack")) %dopar% {
                                
                                universe <- decision_space[i, ]
                                
                                tryCatch({
                                  df_subset <- df_type_function(df = df, data_type = universe$data_type, w1 = w1)
                                  df_subset <- exclusion_function(df_subset, universe$exclusion)
                                  df_subset <- exposure_function(df_subset)
                                  df_subset <- outcome_function(df_subset, universe$outcome_label)
                                  df_subset <- missingness_function(df_subset, universe$missing_data) 
                                  
                                  frm <- formula_function("outcome", "exposure", universe$adjustment_label)
                                  res <- model_function(frm, df_subset, universe$model_type)
                                  RR <- conversion_function(res, universe$model_type)
                                  
                                  universe$RR <- RR$estimate
                                  universe$conf.low <- RR$conf.low
                                  universe$conf.high <- RR$conf.high
                                  universe$p.value <- RR$p.value
                                  universe$error_msg <- NA_character_ 
                                  universe
                                  
                                }, error = function(e) {
                                  universe$RR <- NA
                                  universe$conf.low <- NA
                                  universe$conf.high <- NA
                                  universe$p.value <- NA
                                  universe$error_msg <- conditionMessage(e)
                                  universe
                                })
                             }
    
    all_results[[length(all_results) + 1]] <- subset_results
    
    # Save intermediate results every batch
    intermediate <- bind_rows(all_results)
    write_rds(intermediate, here(paste0("data/results/intermediate_results_", sub_start, "_to_", sub_end, "_", Sys.Date(), ".RDS")))
    }
  
  plan(sequential)
  final_results <- bind_rows(all_results)
  write_rds(final_results, here(paste0("data/results/final_results_", sub_end, Sys.Date(), ".RDS")))
}


