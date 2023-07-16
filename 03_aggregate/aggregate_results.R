## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
##' *INFO*
## 1)
##
## TODO
## 1.
##
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. LOAD ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

results_stage_df <- read_rds("data/02_manipulated/RID_results_stage.rds")
results_end_df <- read_rds("data/02_manipulated/RID_results_end.rds")


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. AGGREGATE ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

results <- bind_rows(results_stage_df, results_end_df)

final_day_types <- c("21", "Geel", "Groen", "Wit", "Bol", "Ploeg")

results_final_day <- results %>%
  filter(type %in% final_day_types) %>%
  group_by(renner_ID, year_int) %>%
  reframe(points = sum(points)) %>%
  group_by(year_int) %>%
  arrange(desc(points)) %>%
  mutate(position = row_number()) %>%
  ungroup() %>%
  mutate(type = "Laatst")

results <- bind_rows(results, results_final_day)


# ## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ## SAVE & CLEAN ####
# ## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  results,
  "data/03_assets/RES_results.rds"
)

write_csv(
  results,
  "data/03_assets/RES_results.csv"
)

clear_script_objects()

