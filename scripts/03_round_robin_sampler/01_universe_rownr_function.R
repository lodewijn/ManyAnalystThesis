# Create a list that contains rownumbers of all universes per decision option.
# This makes sampling universes per specific decision/option easier with larger decision spaces

# This will create option-lists, within decision-lists, within a general list, with the following structure:
    ### universe_rownumbers
          ### data_type
              ### long_w1
                  ### 1, 2, 3, rownumbers...
              ### long_nostrict
                  ### 4, 5, 6, rownumbers...
          ### outcome
              ### event_ever
                  ### 1, 3, 5, rownumbers...
              ### event_ever + age_at_event
                  ### 2, 4, 6, rownumbers...

universe_rownumbers_function <- function(decision_space) {
  set.seed(260722)                       # set seed to ensure reproducibility
  decision_cols <- names(decision_space) # create columns with the same names as in the decision space

  # First, create an empty general list that will later contain the row numbers of universes
  universe_rownumbers <- list()          
  
  # Then loop over columns in the decision space to create the decision and option lists
  for (dec in decision_cols) {
    
    # Set up list structure with decision-lists
    universe_rownumbers[[dec]] <- list() # create separate lists for all individual decisions within the general list
    
    # Create vector with all options in the decision space
    options <- decision_space[[dec]]     # access all options in the decision column individually
    
    # When options are lists (which is the case in the adjustment set and outcome column)
    if (is.list(options)) {
      options <- sapply(options, function(x) paste(sort(x), collapse = "+")) # if there are multiple variables within an option, they are converted to one variable and separated by +
      
      # If they are not lists, just keep them as is (as characters)
    } else {
      options <- as.character(options)   # all variable names are seen as characters
    }
    
    # Set up list structure with option-lists within the decision-lists
    for (opt in unique(options)) {
      
      # Create a new list within the decision-list containing the row numbers of universes that contain each specific option
      universe_rownumbers[[dec]][[opt]] <- which(options == opt) 
      # the which() function checks in which rows of the 'options' vector the value equals the unique options 
    }
  }
  
  # Write RDS file to be able to access the universe rownumbers at a different point in time
  write_rds(universe_rownumbers, here("data/universe_rownumbers/universe_rownumbers.RDS"))
  
  universe_rownumbers
}
