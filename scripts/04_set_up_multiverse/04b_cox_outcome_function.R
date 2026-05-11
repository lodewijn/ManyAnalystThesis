library(tidyverse)

############ COX OUTCOME ############ 

# Since cox requires time-to-event data, the operationalisation of the outcome
# differs from the outcomes of the other models. In this case, we need a binary operator 
# (did people have an event or not 0/1), and a time variable (did the event happen within
# the time frame of the survey). For this, we need to know the age when participants were first
# interviewed, the age at event (if they had any), and the age at which they left the survey 
# (in case they left the survey before having an event - censoring). People who had an event
# before they participated in SHARE were truncated.

# Because the age of death is also available, three out of seven outcome operationalisations could be 
# tested using cox:

    # "age_at_event+death_by_event+event_ever" 
    # "death_by_event+event_ever"    
    # "age_at_event+event_ever"

# In these operationalisations, event_ever is not used directly, but since both age variables
# implicitly assume the event happened ever (event_ever), to simplify comparison with the other 
# statistical models, it was decided to use these same outcome operationalisations.

cox_outcome_function <- function(df, outcome_label) {
  
# General age variables needed for time variables
  df <- df |>
    group_by(mergeid) |>
    mutate(
      # Since the starting times may differ per person (e.g. if their first time 
      # participating is in different waves), we use their youngest recorded age at the interviews.
      age_first_wave = min(age_int),
      # To model dropout/censoring we use the last recorded age, in case they did not get the event.
      age_last_wave = max(age_int))

  
# --- (OUT) age_at_event + death_by_event
  if (outcome_label == "age_at_event+death_by_event+event_ever") {
      
      # To model the age at the event, while accounting for the fact that many rows are NA 
      # (e.g. if someone never had an event) we take the youngest age at either having a stoke or heart attack.
      # NOTE: In a lot of the participants, the event occurred before they entered the study 
      # (age_event < age_first_wave) which is a problem. Therefore, only events occurring during follow-up
      # were used.
      
    
    df <- df |> mutate(
      
      # Take the earliest age any of the events (stroke/heart attack without death, and
      # death due to stroke/heart attack)
      
      age_event_during_SHARE = pmin(
        
        # Heart attack ever
        ifelse(ph009_1 >= age_first_wave, ph009_1, NA),
        
        # Stroke ever
        ifelse(ph009_4 >= age_first_wave, ph009_4, NA),
        
        # Death due to stroke/heart attack
        ifelse((xt011_ == "A heart attack" | xt011_ == "A stroke") & xt010_ >= age_first_wave, 
               xt010_, NA),
        
        na.rm = TRUE
      )
    ) |>
    
    # Since it is not possible that people have reported an event (except death) in the future (after their
    # last interview), the age at the event cannot be larger than the age at the last interview.
    # Also, implausible ages were removed.
    filter(
      is.na(age_event_during_SHARE) |  # keep people without events
           age_event_during_SHARE <= 110) |> # remove implausible values for people with events
    
    # Exit age is either the age people had an event (1) or died from the event (1), 
    # or if they did not have an event (0), the age at their last interview/wave.
      mutate(exit_age = ifelse(!is.na(age_event_during_SHARE), 
                               age_event_during_SHARE, age_last_wave)) |>
    
      # Because cox cannot handle with repeated measures, for now just take the baseline
      # (first occurrence)
      slice(1) |>
      ungroup() |>
  
      # If people had an event during (or after in case of death) their participation in SHARE, the outcome is 1, 
      # otherwise it is 0 (as events that happened before participating cannot be taken into account). 
      mutate(outcome = ifelse(!is.na(age_event_during_SHARE), 
                                        1, 0))
  }
  
  
# --- (OUT) age_at_event 
  else if (outcome_label == "age_at_event+event_ever") {
    
    df <- df |> mutate(
      
      # Take the earliest age any of the events (stroke/heart attack without death)
      age_event_during_SHARE = pmin(
        
        # Heart attack ever
        ifelse(ph009_1 >= age_first_wave, ph009_1, NA),
        
        # Stroke ever
        ifelse(ph009_4 >= age_first_wave, ph009_4, NA),
        
        na.rm = TRUE
      )
    ) |>
      
      # Remove implausible ages (also events occurring after the last wave, as death is not included here).
      filter(
        is.na(age_event_during_SHARE) |  # keep people without events
          (age_event_during_SHARE <= age_last_wave & # remove people with events later than last wave
             age_event_during_SHARE <= 100) # keep people who are 100 years old or younger
      ) |>
      
      # Exit age
      mutate(exit_age = ifelse(!is.na(age_event_during_SHARE), 
                               age_event_during_SHARE, age_last_wave)
      ) |>
      
      # Because cox cannot handle with repeated measures, for now just take the baseline
      # (first occurrence)
      slice(1) |>
      ungroup() |>
      
      # Binary outcome
      mutate(outcome = ifelse(!is.na(age_event_during_SHARE), 
                              1, 0))
  }
  
# --- (OUT) death_by_event 
  else {
      
    df <- df |> mutate(
      
      # Take the earliest age any of the events (death due to stroke/heart attack)
      age_event_during_SHARE =ifelse((xt011_ == "A heart attack" | xt011_ == "A stroke") 
                                     & xt010_ >= age_first_wave, xt010_, NA)) |>
        
        # Remove implausible ages.
        filter(
          is.na(age_event_during_SHARE) |  # keep people without events
               age_event_during_SHARE <= 100) |> # keep people who are 100 years old or younger
        
        # Exit age
        mutate(exit_age = ifelse(!is.na(age_event_during_SHARE), 
                                 age_event_during_SHARE, age_last_wave)
        ) |>
        
        # Because cox cannot handle with repeated measures, for now just take the baseline
        # (first occurrence)
        slice(1) |>
        ungroup() |>
        
        # Binary outcome
        mutate(outcome = ifelse(!is.na(age_event_during_SHARE), 
                                1, 0))
    }
  
    return(df)
}

