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

riders_df <- read_rds("C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/01_validated/RID_riders.rds")
participants_df <- read_rds("C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/01_validated/PAR_participants.rds")

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. AGGREGATE ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

participants_df_long <- participants_df %>%
  pivot_longer(starts_with("Renner"),
               names_to = "renner_position",
               values_to = "renner_ID") %>%
  select(1:7, renner_position, renner_ID, everything()) %>%
  pivot_longer(
    #cols = starts_with(c("StandAlg", "StandDag", "PuntenE")),
    cols = c(PuntenE1:PuntenE21, StandDag1:StandDag21, StandAlg1:StandAlg21),
    names_to = c(".value", "day_col"),
    names_pattern = "(StandAlg|StandDag|PuntenE)(\\d+)",
    values_drop_na  = TRUE
  )


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 3. COMBINE ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

full_df <-riders_df %>%
  full_join(participants_df_long,
            by = c("rennerID" = "renner_ID",
                   "year_int"),
            suffix = c("_rider", "_participants")
  )

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  full_df,
  "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/03_assets/ALL_asset.rds"
)

write_csv(
  full_df,
  "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/03_assets/ALL_asset.csv"
)

clear_script_objects()

