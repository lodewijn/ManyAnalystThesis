# Round Robin sampler function
round_robin_sampler <- function(decision_space, universe_rownumbers, n_per_option, seed) {
  set.seed(seed)                         # set seed to ensure reproducibility
  decision_cols <- names(decision_space) # create columns with the same names as in the decision space
  n <- nrow(decision_space)              # number of rows in the decision space
  sampled <- logical(n)                  # default setting where none of the rows is sampled yet (returns FALSE n times)
  
  # Keep the loop running until either:
  # 1. there are no more universes left to sample
  # 2. the number of universes per option is satisfied
  while (TRUE) {
    # Before the loop is ran, the 'added' variable is reset to FALSE 
    added <- FALSE
    
    # Loop over all decisions
    for (dec in decision_cols) {
      
      # Loop over all options (within decisin loop)
      for (opt in names(universe_rownumbers[[dec]])) {
        
        # Create vector that contains all universe IDs (rownumbers) per option
        universeID <- universe_rownumbers[[dec]][[opt]]
        
        # Create vector that contains only those universe IDs that have NOT been sampled before
        # (also in other decisions/option loops as 'sampled' is defined outside the loop this is one vector
        # for all decisions/options that marks whether a universe ID was sampled before)
        IDs_not_yet_sampled <- universeID[!sampled[universeID]]
        
        # If all IDs are sampled before reaching 'n_per_option', the loop stops
        if (length(IDs_not_yet_sampled) == 0) next
        
        # To control how many universes are sampled per option, check if the number of sampled universes is 
        # larger or equal to 'n_per_option', if that's the case, the loop stops
        if (sum(sampled[universeID]) >= n_per_option) next
        
        # From the not-yet-sampled IDs sample 1 universe
        next_universe <- IDs_not_yet_sampled[sample.int(length(IDs_not_yet_sampled), 1)]
        
        # Change the sampled-status of this universe in the 'sampled' vector
        # to make sure each universe is only sampled once.
        sampled[next_universe] <- TRUE
        
        # When the full loop is finished, one sampled universe is added to 'sampled'
        added <- TRUE
      }
    }
    
    # This way, if there are no more universes that can be sampled, or when there are
    # enough universes per option, (so no new universes are added and the point where 'added <- TRUE' 
    # is never reached (and added <- FALSE is the default), the loop stops running.
    if (!added) break
  }
  
  # Show which universe IDs are sampled
  which(sampled)
}

