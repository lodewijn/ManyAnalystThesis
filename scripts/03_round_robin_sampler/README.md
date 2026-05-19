# Round Robin Sampler
The Round Robin sampler was implemented in two steps. First, decision
options were mapped to corresponding row numbers in the full decision space (`01_universe_rownr_function`). Then, row
numbers were sampled according to the Round Robin algorithm and used to select universes from
the original decision space (`02_round_robin_sampler_function`). 

*Note: it is sufficient to only run `03_run_all_round_robin_scripts` when reproducing these results.*

## Row Numbers
Create a list that contains rownumbers of all universes per decision option.
This makes sampling universes per specific decision/option easier with larger decision spaces

This will create option-lists, within decision-lists, within a general list, with the following structure:

``` plaintext
├── universe_rownumbers
│   ├── data_type
│          └── long_w1
│                 └── 1, 2, 3, rownumbers...
│          └── long_nostrict
│                 └── 4, 5, 6, rownumbers...
│   ├── outcome
│          └── event_ever
│                 └── 1, 3, 5, rownumbers...
│          └── event_ever + age_at_event
│                 └── 2, 4, 6, rownumbers...
```