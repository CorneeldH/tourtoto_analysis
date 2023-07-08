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

results_end_df <- read_rds("C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/01_validated/RID_results_end.rds")


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. MODIFY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Split to apply different mapping
yellow <- results_end_df %>%
  select(starts_with("Geel"), year_int) %>%
  # Make appropriate data structure so the points can be awarded with a simple mapping
  pivot_longer(starts_with("Geel"),
               names_to = c("type", "yellow_position"),
               names_pattern = "([A-Za-z]+)(\\d+)$",
               values_to = "renner_ID"
  ) %>%
  map_cat_to_num("yellow_position", "points") %>%
  rename(position = yellow_position)


other_classements <- results_end_df %>%
  select(!starts_with("Geel")) %>%
  # Make appropriate data structure so the points can be awarded with a simple mapping
  pivot_longer(
    cols = -c(year_int),
    names_to = c("type", "position"),
    names_pattern = "([A-Za-z]+)(\\d+)$",
    values_to = "renner_ID"
  ) %>%
  filter(renner_ID != 0) %>%
  map_cat_to_num("position", "points")


results_end_df <- bind_rows(yellow, other_classements) %>%
# Set position to int for binding with results stages
  mutate(position = as.integer(position))

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


write_rds(
  results_end_df,
  "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/02_manipulated/RID_results_end.rds"
)

clear_script_objects()
