# Data Cleaning

First, the `01_ files` contain data cleaning in all waves separately. 

- In these files, all relevant variables needed for the multiverse are selected 
from the separate raw data files.
- Then, the smaller data sets containing the relevant variables are merged 
into one large data set per wave (called `w1` - `w7`) based on the matching ID variables. 
- Lastly, new csv files are written containing the clean data of all waves.

*Note: not all variables were available in all waves, so for some waves*
*different variables are included in the clean data set.* 

--- 
Secondly, the `02_ file` contains functions to convert all time-related 
variables to numeric variables.

- In different waves, these variables had different data classes, which becomes 
problematic when trying to merge all waves into one large data set. Therefore, 
in this file, all age and year variables are converted to numeric values. 
- Then, the csv files with the clean data are updated with the new numerical 
time-variables.

---
Then, the `03_ file` can be used to run the cleaning scripts all at once, 
without having to open and run them all separately.

---
Since the end-of-life data contains the cause of death of people in earlier waves, 
this dataset could only be merged with the other data after all waves were combined 
(the merge-IDs of people who died before a wave are not in that same wave). Therefore, 
in the `04_ file` the data from all waves were first merged, and then joined with the 
end-of-life datasets from SHARE.