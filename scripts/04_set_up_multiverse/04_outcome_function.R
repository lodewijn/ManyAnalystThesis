library(tidyverse)

############ OUTCOME ############ 

# Seven outcome combinations are used
# "event_ever", "age_at_event", "since_last_int", "death_by_event"
# "event_ever"
# "event_ever", "age_at_event"
# "event_ever", "age_at_event", "death_by_event"
# "event_ever", "age_at_event", "since_last_int"
# "event_ever", "since_last_int", "death_by_event"
# "event_ever", "death_by_event"

outcome_function <- function(df, outcome_label) {
  
  # --- (OUT) age_at_event + death_by_event + event_ever + since_last_int
  if (outcome_label == "age_at_event+death_by_event+event_ever+since_last_int") {
    
    df <- df |> mutate(event_ever_binary = ifelse(ph006d1 == "Selected" 
                                                  | ph006d4 == "Selected", 
                                                  1, 0),
                       
                       since_last_int_binary = ifelse(ph072_1 == "Yes" 
                                                      | ph072_2 == "Yes", 
                                                      1, 0),
                       
                       death_by_event_binary = ifelse(xt011_ == "A heart attack" 
                                                      | xt011_ == "A stroke", 
                                                      1, 0),
                       
                       # Since NAs in the outcome are often meaningful (for example when people
                       # do not respond because they did not have an event), the outcome is coded as
                       # having an event (1), and when no event was recorded (either not asked,
                       # refused, or actually no event happened) 0 was used.
                       # This makes the assumption that not asked = no event recorded.
                       
                       event_ever_binary     = replace_na(event_ever_binary, 0),
                       since_last_int_binary = replace_na(since_last_int_binary, 0),
                       death_by_event_binary = replace_na(death_by_event_binary, 0),
                       
                       # Binary Outcome Variable
                       outcome = ifelse(!is.na(ph009_1) | !is.na(ph009_4) 
                                  | death_by_event_binary == 1 
                                  | event_ever_binary == 1 
                                  | since_last_int_binary == 1, 
                                  1, 0))
  }
  
  # --- (OUT) event_ever
  else if (outcome_label == "event_ever") {
    
    df <- df |> mutate(event_ever_binary = ifelse(ph006d1 == "Selected" 
                                                  | ph006d4 == "Selected", 
                                                  1, 0),
                       
                       event_ever_binary     = replace_na(event_ever_binary, 0),
                       
                       # Binary Outcome Variable
                       outcome = ifelse(event_ever_binary == 1, 
                                  1, 0))
    
  }
  
  # --- (OUT) age_at_event + event_ever
  else if (outcome_label == "age_at_event+event_ever") {
    
    df <- df |> mutate(event_ever_binary = ifelse(ph006d1 == "Selected" 
                                                  | ph006d4 == "Selected", 
                                                  1, 0),
                       
                       event_ever_binary     = replace_na(event_ever_binary, 0),
                       
                       # Binary Outcome Variable
                       outcome = ifelse(!is.na(ph009_1) | !is.na(ph009_4)
                                  | event_ever_binary == 1, 
                                  1, 0))
    
  }
  
  # --- (OUT) age_at_event + death_by_event + event_ever
  else if (outcome_label == "age_at_event+death_by_event+event_ever") {
    
    df <- df |> mutate(event_ever_binary = ifelse(ph006d1 == "Selected" 
                                                  | ph006d4 == "Selected", 
                                                  1, 0),
                       
                       death_by_event_binary = ifelse(xt011_ == "A heart attack" 
                                                      | xt011_ == "A stroke", 
                                                      1, 0),
                       
                       event_ever_binary     = replace_na(event_ever_binary, 0),
                       death_by_event_binary = replace_na(death_by_event_binary, 0),
                       
                       # Binary Outcome Variable
                       outcome = ifelse(!is.na(ph009_1) | !is.na(ph009_4) 
                                  | death_by_event_binary == 1 
                                  | event_ever_binary == 1, 
                                  1, 0))
  }
  
  # --- (OUT) age_at_event + event_ever + since_last_int
  else if (outcome_label == "age_at_event+event_ever+since_last_int") {
    
    df <- df |> mutate(event_ever_binary = ifelse(ph006d1 == "Selected" 
                                                  | ph006d4 == "Selected", 
                                                  1, 0),
                       
                       since_last_int_binary = ifelse(ph072_1 == "Yes" 
                                                      | ph072_2 == "Yes", 
                                                      1, 0),

                       event_ever_binary     = replace_na(event_ever_binary, 0),
                       since_last_int_binary = replace_na(since_last_int_binary, 0),

                       # Binary Outcome Variable
                       outcome = ifelse(!is.na(ph009_1) | !is.na(ph009_4)
                                  | event_ever_binary == 1 
                                  | since_last_int_binary == 1, 
                                  1, 0))
  }
  
  # --- (OUT) death_by_event + event_ever + since_last_int
  else if (outcome_label == "death_by_event+event_ever+since_last_int") {
    
    df <- df |> mutate(event_ever_binary = ifelse(ph006d1 == "Selected" 
                                                  | ph006d4 == "Selected", 
                                                  1, 0),
                       
                       since_last_int_binary = ifelse(ph072_1 == "Yes" 
                                                      | ph072_2 == "Yes", 
                                                      1, 0),
                       
                       death_by_event_binary = ifelse(xt011_ == "A heart attack" 
                                                      | xt011_ == "A stroke", 
                                                      1, 0),
                       
                       
                       event_ever_binary     = replace_na(event_ever_binary, 0),
                       since_last_int_binary = replace_na(since_last_int_binary, 0),
                       death_by_event_binary = replace_na(death_by_event_binary, 0),
                       
                       # Binary Outcome Variable
                       outcome = ifelse(death_by_event_binary == 1 
                                  | event_ever_binary == 1 
                                  | since_last_int_binary == 1, 
                                  1, 0))
  }
  
  # --- (OUT) death_by_event + event_ever
  else {
    
    df <- df |> mutate(event_ever_binary = ifelse(ph006d1 == "Selected" 
                                                  | ph006d4 == "Selected", 
                                                  1, 0),
                       
                       death_by_event_binary = ifelse(xt011_ == "A heart attack" 
                                                      | xt011_ == "A stroke", 
                                                      1, 0),
                       
                       event_ever_binary     = replace_na(event_ever_binary, 0),
                       death_by_event_binary = replace_na(death_by_event_binary, 0),
                       
                       # Binary Outcome Variable
                       outcome = ifelse(death_by_event_binary == 1 
                                  | event_ever_binary == 1, 
                                  1, 0))
  }
}
