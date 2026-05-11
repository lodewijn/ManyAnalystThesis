library(foreach)
library(doFuture)
library(future)
library(here)

multiverse_function <- function(df, decision_space, w1, subset_size) {
  
  # Source All Functions
  source(here("scripts/04_set_up_multiverse/01_data_type_function.R"))
  source(here("scripts/04_set_up_multiverse/02_exclusion_function.R"))
  source(here("scripts/04_set_up_multiverse/03_exposure_function.R"))
  source(here("scripts/04_set_up_multiverse/04_outcome_function.R"))
  source(here("scripts/04_set_up_multiverse/04b_cox_outcome_function.R"))
  source(here("scripts/04_set_up_multiverse/05_missingness_function.R"))
  source(here("scripts/04_set_up_multiverse/06_formula_function.R"))
  source(here("scripts/04_set_up_multiverse/06b_cox_formula_function.R"))
  source(here("scripts/04_set_up_multiverse/07_model_function.R"))
  source(here("scripts/04_set_up_multiverse/07b_cox_model_function.R"))
  source(here("scripts/04_set_up_multiverse/08_conversion_function.R"))

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
                                          "model_function", "conversion_function", "missingness_function",
                                          "cox_outcome_function", "cox_formula_function", "cox_model_function"),
                              .packages = c("tidyverse", "broom", "broom.mixed", "lme4", "geepack", "survival")) %dopar% {
                                
                                universe <- decision_space[i, ]
                                
                                tryCatch({
                                  df_subset <- df_type_function(df, universe$data_type, w1)
                                  df_subset <- exclusion_function(df_subset, universe$exclusion)
                                  df_subset <- exposure_function(df_subset)
                                  
                                  # --- COX REQUIRES DIFFERENT FUNCTIONS
                                  if (universe$model_type == "cox_haz") {
                                    df_subset <- cox_outcome_function(df_subset, universe$outcome_label)
                                    df_subset <- missingness_function(df_subset, universe$missing_data)
                                    frm <- cox_formula_function("exposure", universe$adjustment_label)
                                    res <- cox_model_function(frm, df_subset)
                                    RR <- conversion_function(res, universe$model_type)  
                                  }
                                  
                                  # --- ALL OTHER STATISTICAL MODELS  
                                  
                                  else {
                                    df_subset <- outcome_function(df_subset, universe$outcome_label)
                                    df_subset <- missingness_function(df_subset, universe$missing_data)
                                    frm <- formula_function("outcome", "exposure", universe$adjustment_label)
                                    res <- model_function(frm, df_subset, universe$model_type)
                                    RR <- conversion_function(res, universe$model_type)
                                  }
                                  
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
    write_rds(intermediate, here(paste0("data/results/all_models_intermediate_results_Univ100_", sub_start, "_to_", sub_end, "_", Sys.Date(), ".RDS")))
  }
  
  plan(sequential)
  final_results <- bind_rows(all_results)
  write_rds(final_results, here(paste0("data/results/all_models_final_results_Univ100_", sub_end, "_", Sys.Date(), ".RDS")))
}


