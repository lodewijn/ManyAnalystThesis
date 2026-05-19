# Variation in Many-Analyst Projects: Harmful or Helpful?

## Introduction
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

## Data
### Raw and Clean Data
Consistent with Kowall et al. (2025), data from waves 1-7 (excluding wave 3) of the
Survey of Health, Ageing and Retirement in Europe (SHARE) were used. SHARE is a
longitudinal panel study conducted across 28 European countries, collecting data on health, social,
economic and environmental policies, since 2004 (Börsch-Supan et al., 2013; SHARE-ERIC, 2024a, 2024b, 2024c, 2024d, 2024e, 2024f) .

#### Accessing the Data
Because the data from the Survey of Health, Ageing, and Retirement
in Europe (SHARE) are only available after registration, they cannot be publicly shared on github. 

**If you are not registered yet**, to access the data, please follow these steps:
- visit: [https://share-eric.eu/data/](https://share-eric.eu/data/)
- go to "Become a User" and follow the steps given on this page
- it can take some time (a few days/weeks) before the registration is complete

**If you are already registered**, to access the data, please follow these steps:
- visit: [https://releases.sharedataportal.eu/users/login](https://releases.sharedataportal.eu/users/login)
- here you see the data files for all waves, in this study only waves 2, 4, 5, 6 and 7 are used, so these are the only ones that need to be downloaded
- note: the SPSS data are used, such as: sharew1_rel9-0-0_ALL_datasets_spss.zip

**After getting access to the full data**, select only those files that are needed in this study.
An example of which data files are relevant and how they should be placed in the 
folder structure can be found in the [data folder](https://github.com/lodewijn/ManyAnalystThesis/tree/main/data).


## Scripts



## Docs
In this file, the manusctipts of the final thesis, as well as the intermediate research report can be found.


### `ManyAnalystThesisCompendium.Rproj`
This is the R project file for the repository. It contains the project settings and configuration. Open this project in RStudio before running any of the analysis files.

### `activate.R in renv file`
Run this file in RStudio before running any of the analysis files to make sure correct package versions are installed.

# Ethics
Ethical approval was granted by Ethics Review Board of the Faculty of Social & Behavioural Sciences at Utrecht University. The ethical approval case number is 25-2021.

# License
This project is licensed under the GNU General Public License v3.0. See the LICENSE file for details.

# Permissions and Access
This archive will indefinitely be publicly available on GitHub. 
Full responsibility for the content of this archive lies with Loesje Ubbink. 
In the case of questions, do not hesitate to contact me by emailing l.ubbink@students.uu.nl or loes.ubbink@gmail.com.

