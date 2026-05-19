# Setting up the Multiverse

## Decision Space
First, the `01_ files` contain the setting up of the decision space.

**Outcome Variable**
The outcome variable in the original paper by Kowall et al. (2025) consisted
of combinations of four different conceptual options, where two of the variables
in the data set were combined into one concept:

-   `ph006d1` / `ph006d4`: Heart attack/stroke ever diagnosed
-   `ph009_1` / `ph009_4`: Age heart attack or stroke
-   `ph072_1` / `ph072_2`: Heart attack / stroke since last interview
-   `xt011_`: Main cause of death
-   `xt010_`: Age at death (used in Cox)

The first code chunk first creates those conceptual options, and then makes all 
possible combinations of those options (ranging from 1 option to all 4). Only the seven operationalisations
that were used in the original paper were used in this multiverse.

**Adjustment Set**
Because of computational and time limits, I decided to only include variables 
in the adjustment set that were used by at least four analysis teams. The second
code chunk creates a list of all different combinations of covariates
(including) the empty set.

**Decision Space**
A data frame containing all possible combinations of 
all decisions is created using `expand.grid`

*Note: for more information about the variables see REAME.md in the data folder.*

**Valid Universes**
All invalid universes were excluded from the decision space. Invalid paths included combinations of both types of cross-sectional data with models
requiring longitudinal data structure (Cox proportional hazards, discrete-time mixed-effects), cross-sectional Wave 1 data with models requiring repeated measures (mixed-effects logistic
regression, generalised estimating equations (GEE)), cross-sectional Wave 1 data with outcomes
that were not available at baseline (event since last interview, cause of death), and Cox models
with outcomes lacking time-to-event variables. For Cox models, although different time-to-event
outcome operationalisations were used by different analysts, most of them used age as a proxy for
time, so this was repeated in the present multiverse analysis. 

