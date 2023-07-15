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

participants_df <- read_rds("data/02_manipulated/PAR_participants.rds")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. AGGREGATE ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

participants_df_long <- participants_df %>%
  pivot_longer(starts_with("Renner"),
               names_to = "renner_position",
               values_to = "renner_ID") %>%
  select(1:7, renner_position, renner_ID, everything()) %>%
  pivot_longer(
    # Cols with points and positions
    cols = matches("(StandAlg|StandDag|PuntenE|pnt_)"),
    names_to = c(".value", "day_col"),
    names_pattern = "(StandAlg|StandDag|PuntenE|pnt_)(.*)",
    values_drop_na  = TRUE
  ) %>%
  mutate(PuntenE = coalesce(PuntenE, pnt_)) %>%
  select(-pnt_)


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3. COMBINE ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# full_df <-riders_df %>%
#   full_join(participants_df_long,
#             by = c("rennerID" = "renner_ID",
#                    "year_int"),
#             suffix = c("_rider", "_participants")
#   )

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  full_df,
  "data/03_assets/ALL_asset.rds"
)

write_csv(
  full_df,
  "data/03_assets/ALL_asset.csv"
)

clear_script_objects()

