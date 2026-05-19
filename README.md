# Variation in Many-Analyst Projects: Harmful or Helpful?
This repository contains the data and R scripts to reproduce the findings for the Master's thesis *Variation in Many-Analyst Projects: Harmful or Helpful? A Multiverse Approach to Address Different Sources of Variation*, 
conducting multiverse analysis based on an existing many-analyst project by Kowall et al. (2025). 

Many-analyst studies have demonstrated substantial variability in effect sizes across independent
researchers, raising questions about whether such variation reflects harmful arbitrary noise or
helpful theoretically meaningful differences. Using the many-analyst project by Kowall et
al. (2025) as a case study in a multiverse analysis, this study aimed to formally quantify the
relative contribution of harmful versus helpful analytical decisions to effect size variation using
inferential statistical methods, including k-sample Anderson-Darling tests, moving beyond
traditional descriptive reporting. Across 4,913 specifications, effect sizes ranged from 0.71 to
1.68, where 65.3% were significantly negative (RR < 1, p < .05), 14.3% significantly positive (RR > 1, p < .05), and 20.4% non-significant. Variability was driven primarily by statistical model
(harmful) and adjustment set (helpful). Sensitivity to adjustment set, driven by including age and
sex, illustrated that differences in results reflected meaningful differences in what was estimated
rather than arbitrary noise, underscoring the importance of considering causal structures prior to
analysis. Analytical decisions were rarely independent, making it difficult to categorise them as
purely harmful or helpful. This is precisely what makes multiverse analysis valuable: rather than
isolating individual decisions, it captures how choices jointly shape results, making variation
transparent and interpretable.

This project aims to answer the research question: To what extent do different types of analysis decisions, including handling
missing data, choice of statistical model and definitions of outcome variables, covariates and target
population, contribute to variation in the outcomes of many-analyst projects?

Folders `data`, `scripts` and `docs` are relevant. More information about those folders and their content can be found below.

*Note: the `results` folder can be found inside the [data folder](https://github.com/lodewijn/ManyAnalystThesis/tree/main/data/results) and code for plotting the results can be found in the [05_results_plots folder](https://github.com/lodewijn/ManyAnalystThesis/tree/main/scripts/05_results_plots).*

# Data
## Raw and Clean Data
Consistent with Kowall et al. (2025), data from waves 1-7 (excluding wave 3) of the
Survey of Health, Ageing and Retirement in Europe (SHARE) were used. SHARE is a
longitudinal panel study conducted across 28 European countries, collecting data on health, social,
economic and environmental policies, since 2004 (Börsch-Supan et al., 2013; SHARE-ERIC, 2024a, 2024b, 2024c, 2024d, 2024e, 2024f) .

### Accessing the Data
Because the data from the Survey of Health, Ageing, and Retirement
in Europe (SHARE) are only available after registration, they cannot be publicly shared on github. 

**If you are not registered yet**, to access the data, please follow these steps:
- visit: [https://share-eric.eu/data/](https://share-eric.eu/data/)
- go to "Become a User" and follow the steps given on this page
- it can take some time (a few days/weeks) before the registration is complete

**If you are already registered**, to access the data, please follow these steps:
- visit: [https://releases.sharedataportal.eu/users/login](https://releases.sharedataportal.eu/users/login)
- here you see the data files for all waves, in this study only waves 1, 2, 4, 5, 6 and 7 are used, so these are the only ones that need to be downloaded
- note: the SPSS data are used, such as: sharew1_rel9-0-0_ALL_datasets_spss.zip

**After getting access to the full data**, select only those files that are needed in this study.
An example of which data files are relevant and how they should be placed in the 
folder structure can be found in the [raw data folder](https://github.com/lodewijn/ManyAnalystThesis/tree/main/data/rawdata).

### DataTypeDFs 
These are the data sets containing data of the four Data Types to see if there were differences in
the number of participants and observations across Data Type options, which was the case: 

- Cross-sectional all waves: 138,807 participants across 336,804 observations.
- Cross-sectional Wave 1: 30,416 participants across 30,416 observations.
- Longitudinal no strict baseline: 87,029 participants across 285,026 observations.
- Longitudinal Wave 1: 23,301 participants across 91,935 observations.

### `ManyAnalystThesisCompendium.Rproj`
This is the R project file for the repository. It contains the project settings and configuration. Open this project in RStudio before running any of the analysis files.

### Reproduce the Environment
Run `renv::restore()` in RStudio before running any of the analysis files to make sure correct package versions are installed.

## Decision Space
To define the decision space, all options of six different decisions made by the teams in
Kowall et al. (2025) were identified based on information provided in the original publication (see
Table 2). The analytical decisions included handling missing data, choice of exclusion criteria,
statistical model and definitions of dependent (outcome) variables, adjustment sets and target
population. When systematically combining all options across decisions, the decision space
consisted of 129,024 universes (`decision_space_raw.csv`). After removing invalid research paths, 82,944 valid universes
remained (`decision_space.csv`). These were stored in the [decision space folder](https://github.com/lodewijn/ManyAnalystThesis/tree/main/data/decision_space).

## Sampled Universes
Because the number of reasonable universes grows exponentially with the number of
decisions and their options, Round Robin sampling was used for approximating multiverse results. 
First, row numbers were mapped for each option, to make the sampling more computationally efficient, see folder 'universe_rownumebers`.
The sampled universes can be found [here](https://github.com/lodewijn/ManyAnalystThesis/tree/main/data/sampled_universes).

## Results 
In this folder, all multiverse results (including test results that can be ignored) are stored. 
Because the files contain the date on which the multiverse results were obtained, the results files are not overwritten. 
The results that were used for the final thesis are `corrected_results_final_2026-04-28.RDS`.

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

# Docs
Under `Thesis_Draft/Thesis_Draft_FINAL`, the manuscript of the final thesis can be found.

# Reproduction Recipe
These results can be reproduced by running the scripts in the following order:

1. Make sure you have at least R version 4.4.2, with the `renv` package installed.
2. Open the project `ManyAnalystThesisCompendium.Rproj`.
3. Run `renv::restore()`.
4. Make sure all data sets from the correct waves are stored in the correct folder by following the folder structure that can be found in the [raw data folder](https://github.com/lodewijn/ManyAnalystThesis/tree/main/data/rawdata).
5. Run `03_run_all_scripts` and `04_add_end_of_life_data` from [01_data_cleaning](https://github.com/lodewijn/ManyAnalystThesis/tree/main/scripts/01_data_cleaning).
6. Run `01_decision_space` from the [02_decision_space](https://github.com/lodewijn/ManyAnalystThesis/tree/main/scripts/02_decision_space).
7. Run `03_run_all_round_robin_scripts` from [03_round_robin_sampler](https://github.com/lodewijn/ManyAnalystThesis/tree/main/scripts/03_round_robin_sampler).
8. Run `10_run_multiverse_results` from [04_set_up_multiverse](https://github.com/lodewijn/ManyAnalystThesis/tree/main/scripts/04_set_up_multiverse).
9. Run `01_density_plots_results_multiverse` and `02_specification_curve` from [05_results_plots](https://github.com/lodewijn/ManyAnalystThesis/tree/main/scripts/05_results_plots).
10. To get the full manuscript, run `Thesis_Draft_FINAL.qmd` from [this folder](https://github.com/lodewijn/ManyAnalystThesis/tree/main/docs/Thesis_Draft/Thesis_Draft_FINAL).

# Ethics
Ethical approval was granted by Ethics Review Board of the Faculty of Social & Behavioural Sciences at Utrecht University. The ethical approval case number is 25-2021.

# License
This project is licensed under the GNU General Public License v3.0. See the [LICENSE](https://github.com/lodewijn/ManyAnalystThesis/blob/main/LICENSE) file for details.

# Permissions and Access
This archive will indefinitely be publicly available on GitHub. 
Full responsibility for the content of this archive lies with Loesje Ubbink. 
In the case of questions, do not hesitate to contact me by emailing l.ubbink@students.uu.nl or loes.ubbink@gmail.com.

# References
Börsch-Supan, A., Brandt, M., Hunkler, C., Kneip, T., Korbmacher, J., Malter, F., Schaan, B.,
Stuck, S., & Zuber, S. (2013). Data Resource Profile: The Survey of Health, Ageing and
Retirement in Europe (SHARE). International Journal of Epidemiology, 42(4), 992–1001.
https://doi.org/10.1093/ije/dyt088

Kowall, B., Ahrenfeldt, L. J., Basten, J., Becher, H., Brand, T., Braun, J., Casjens, S., Claessen, H.,
Denz, R., Diebner, H. H., Diexer, S., Eisemann, N., Furrer, E., Galetzka, W., Girschik, C.,
Karch, A., Mikolajczyk, R., Peters, M., Rospleszcz, S., … Rübsamen, N. (2025). Marital
status and risk of cardiovascular disease – a multi-analyst study in epidemiology.
European Journal of Epidemiology, 40(5), 497–509.
https://doi.org/10.1007/s10654-025-01235-8

SHARE-ERIC. (2024a). Survey of Health, Ageing and Retirement in Europe (SHARE) Wave 1.
SHARE-ERIC. https://doi.org/10.6103/SHARE.W1.900

SHARE-ERIC. (2024b). Survey of Health, Ageing and Retirement in Europe (SHARE) Wave 2.
SHARE-ERIC. https://doi.org/10.6103/SHARE.W2.900

SHARE-ERIC. (2024c). Survey of Health, Ageing and Retirement in Europe (SHARE) Wave 4.
SHARE-ERIC. https://doi.org/10.6103/SHARE.W4.900

SHARE-ERIC. (2024d). Survey of Health, Ageing and Retirement in Europe (SHARE) Wave 5.
SHARE-ERIC. https://doi.org/10.6103/SHARE.W5.900

SHARE-ERIC. (2024e). Survey of Health, Ageing and Retirement in Europe (SHARE) Wave 6.
SHARE-ERIC. https://doi.org/10.6103/SHARE.W6.900

SHARE-ERIC. (2024f). Survey of Health, Ageing and Retirement in Europe (SHARE) Wave 7.
SHARE-ERIC. https://doi.org/10.6103/SHARE.W7.900

# AI Statement
During this thesis, generative AI (Claude Sonnet 4.6, Claude Opus 4.6, Claude Opus 4.7)
was used for text editing/improving grammar and assistance/debugging during coding.