library(here)

# Load Cleaned Data From All Waves
df <- readRDS(here("data/cleandata/df_all_waves.RDS"))
w1 <- readRDS(here("data/cleandata/w1_clean.RDS"))

# Decision Space: Sampled Universes
sampled_universes <- readRDS(here("data/sampled_universes/sampled_universes.RDS"))

# Source All Functions
source(here("scripts/04_set_up_multiverse/01_data_type_function.R"))
source(here("scripts/04_set_up_multiverse/02_exclusion_function.R"))
source(here("scripts/04_set_up_multiverse/03_exposure_function.R"))
source(here("scripts/04_set_up_multiverse/04_outcome_function.R"))
source(here("scripts/04_set_up_multiverse/05_missingness_function.R"))
source(here("scripts/04_set_up_multiverse/06_formula_function.R"))
source(here("scripts/04_set_up_multiverse/07_model_function.R"))
source(here("scripts/04_set_up_multiverse/08_conversion_function.R"))
source(here("scripts/04_set_up_multiverse/09_multiverse_function.R"))
source(here("scripts/04_set_up_multiverse/09b_multiverse_function_parallel.R"))
source(here("scripts/04_set_up_multiverse/09c_multiverse_function_parallel_intermediate.R"))
       
set.seed(26072022)
mini <- sample.int(1920, 5)
minidecisionspace <- sampled_universes[c(mini),]

spec <- minidecisionspace[1, ]

df_subset <- df_type_function(df, spec$data_type, w1)
df_subset <- exclusion_function(df_subset, spec$exclusion)
df_subset <- exposure_function(df_subset)
df_subset <- outcome_function(df_subset, spec$outcome_label)
df_subset <- missingness_function(df_subset, spec$missing_data) 
frm <- formula_function("outcome", "exposure", spec$adjustment_label)
res <- model_function(frm, df_subset, spec$model_type)
RR <- conversion_function(res, spec$model_type)
RR

system.time({
  spec <- minidecisionspace[1, ]
  df_subset <- df_type_function(df, spec$data_type, w1)
  df_subset <- exclusion_function(df_subset, spec$exclusion)
  df_subset <- exposure_function(df_subset)
  df_subset <- outcome_function(df_subset, spec$outcome_label)
  df_subset <- missingness_function(df_subset, spec$missing_data)
  frm <- formula_function("outcome", "exposure", spec$adjustment_label)
  res <- model_function(frm, df_subset, spec$model_type)
})


RR <- multiverse_function_parallel_intermediate(df, minidecisionspace, w1)


frm_glmer <- update(frm, . ~ . + (1 | mergeid))
glmer(frm_glmer, data = df_subset, family = binomial(link = "logit"),
      control = glmerControl(optCtrl = list(maxfun = 10000)), nAGQ = 0)


# Why does glmer fail? Except when nAGQ = 0
# How many people appear once? FULL DF
nrow <- tally(group_by(df, mergeid))
n1 <- which(nrow$n == 1)
length(n1) # 51778
nlargerthan1 <- which(nrow$n > 1)
length(nlargerthan1) # 87029

# How many people appear once? SUBSET DF
nrow <- tally(group_by(df_subset, mergeid))
n1 <- which(nrow$n == 1)
length(n1) # 22538
nlargerthan1 <- which(nrow$n > 1)
length(nlargerthan1) # 626

# The waves variable needs to be numeric
df_subset <- df_subset |> 
  mutate(wave_num = as.numeric(gsub("w", "", wave)),
         mergeid = as.factor(mergeid)) |>
  arrange(mergeid)

# Fit the GEE model
geeglm(frm, 
                waves = wave_num, 
                id = mergeid, 
                data = df_subset, 
                family = binomial(link = "logit"), 
                corstr = "exchangeable")

# Gets an error because there are NAs in br001_
# GEE is not able to handle NAs

# Check NAs in outcome, exposure, and all covariates
df_subset |> 
  select(outcome, exposure , age_int , br001_ , country , phactiv) |>  # adjust to match your formula
  summarise(across(everything(), ~sum(is.na(.))))



# In which step does this happen? The missingness step
df_subset <- df_type_function(df, spec$data_type, w1)
df_subset |> count(mergeid) |> filter(n > 1) |> nrow()  # How many with >1 obs?

df_subset <- exclusion_function(df_subset, spec$exclusion)
df_subset |> count(mergeid) |> filter(n > 1) |> nrow()

df_subset <- exposure_function(df_subset)
df_subset |> count(mergeid) |> filter(n > 1) |> nrow()

df_subset <- outcome_function(df_subset, spec$outcome_label)

# Check what happens with NAs in follow up
df_subset |> 
  group_by(wave) |> 
  summarise(across(c(age_int, dn042_, country, dn010_, br001_, phactiv), 
                   ~sum(is.na(.))))

# It becomes clear that dn010 (education) and br001 (ever smoked daily) 
# have a large number of NAs in follow up waves. Since these variables
# are not time-variant


# Some checks regarding the outcomes
sum(df$death_by_event_binary == 1 & df$event_ever_binary == 0) # 3198
sum(df$death_by_event_binary == 1 & df$since_last_int_binary == 0) # 4867
sum(df$death_by_event_binary == 0 & df$event_ever_binary == 1) # 48656
sum(df$death_by_event_binary == 0 & df$since_last_int_binary == 1) # 5370

# event_ever + death + since_last + age
mean(df$outcome)
# 0.1626287

# event_ever
mean(df$outcome)
# 0.1502031

# event_ever + age
mean(df$outcome)
# 0.150209

# age_at_event + event_ever + since_last_int
mean(df$outcome)
# 0.1532048

