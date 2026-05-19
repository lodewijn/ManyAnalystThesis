# Scripts
This folder contains all R and qmd scripts used to prepare the data, create the decision space, 
sample the decision space, run the multiverse analysis and plot the results.

## 01 Data Cleaning
Because the data consisted of different SPSS data files per topic and per wave, variables from many
different data frames were combined into one large data set with all relevant variables from all waves.

- `01_select_variables`: Separate cleaning file per wave, selecting the relevant variables from different wave-specific data sets. This was done so it was possible to make wave-specific changes or fixes.
- `02_variables_to_numeric`: Not all time variables were numeric, so they were converted to numeric.
- `03_run_all_scripts`: When reproducing these results, it is not necessary to run all wave-specific files individually. Using this R file, all files in `01_` and `02_` are sourced.
- `04_add_end_of_life_data`: Since the end-of-life data contains the cause of death of people in earlier waves, this dataset could only be merged with the other data after all waves were combined (the merge-IDs of people who died before a wave are not in that same wave). Therefore, in the 04_ file the data from all waves were first merged, and then joined with the end-of-life datasets from SHARE.

*Note: it is sufficient to only run `03_run_all_scripts` and `04_add_end_of_life_data` when reproducing these results.*

## 02 Decision Space
This code systematically combines all decision options and stores the valid decision space in a .csv file.

## 03 Round Robin Sampler
The Round Robin sampler was implemented in two steps. First, decision
options were mapped to corresponding row numbers in the full decision space (`01_universe_rownr_function`). Then, row
numbers were sampled according to the Round Robin algorithm and used to select universes from
the original decision space (`02_round_robin_sampler_function`). 

*Note: it is sufficient to only run `03_run_all_round_robin_scripts` when reproducing these results.*

## 04 Multiverse Analysis
The functions for all analysis steps were implemented in separate R files (`01_`-`08_`) and then looped over the decision space (use only `09e_multiverse_function_final_corrected`).

*Note: it is sufficient to only run `10_run_multiverse_results` when reproducing these results, as this sources all multiverse functions.*

## 05 Results Plots
Density plots (`01_density_plots_results_multiverse`) and a specification curve (`02_specification_curve`) were used to describe the robustness of the results. Images (png) of these plots were stored in the `docs/Thesis_Draft` file, under `figures`.