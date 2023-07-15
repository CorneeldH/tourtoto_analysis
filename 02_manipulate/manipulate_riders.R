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

riders_df <- read_rds("data/01_validated/RID_riders.rds")


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. MODIFY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# Years have different cut-off points for multiplier (horses)
riders_2022 <- riders_df %>%
  filter(year_int >= 2022) %>%
  map_num_to_num("gekozen", "multiplier_0_2_8_23")

riders_2020 <- riders_df %>%
  filter(year_int %in% c(2020, 2021)) %>%
  map_num_to_num("gekozen", "multiplier_0_2_6_16")


riders_before_2020 <- riders_df %>%
  filter(year_int < 2020) %>%
  mutate(multiplier = 1)


# Combine them again
riders <- bind_rows(riders_2022,
                    riders_2020,
                    riders_before_2020)

# Get it all in one column and remove the temporary columns
multiplier_columns <- riders %>%
  select(starts_with("multiplier")) %>%
  names()


riders <- riders %>%
  mutate(multiplier = coalesce(!!!syms(multiplier_columns))) %>%
  select(!(starts_with("multiplier") & !ends_with("multiplier")))


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  riders,
  "data/02_manipulated/RID_riders.rds"
)

clear_script_objects()
