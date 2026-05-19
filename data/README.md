There are several data folders, containing different data frames. 

- `rawdata` & `cleandata`: The raw and cleaned data from SHARE.
- `decision_space`: After creating the decision space, this is stored as a .csv file.
- `universe_rownumbers` & `sampled_universes`: In the Round Robin sampler, row numbers were mapped for each option and then these rownumbers were sampled from the decision space, to make the sampling more computationally efficient.
- `results`: Multiverse results containing risk ratios of all universes in the sample of the decision space.
- `DataTypeDfs`: These are the data sets containing data of the four Data Types to see if there were differences in the number of participants and observations across Data Type options.