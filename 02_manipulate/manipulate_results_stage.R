## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
##' *INFO*
## 1)
##
## TODO
## 1. Filter columns
##
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. LOAD ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

results_stage_df <- read_rds("C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/01_validated/RID_results_stage.rds")


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. MODIFY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


results_stage_df <- results_stage_df %>%
  # Prepare for binding with results_end
  rename(type = Etappe) %>%
  mutate(type = as.character(type)) %>%
  select(-datum) %>%
  # Make appropriate data structure so the points can be awarded with a simple mapping
  pivot_longer(starts_with("R"),
               names_to = "position",
               values_to = "renner_ID") %>%
  mutate(position = parse_number(position)) %>%
  map_cat_to_num("position", "points")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  results_stage_df,
  "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/02_manipulated/RID_results_stage.rds"
)

clear_script_objects()
