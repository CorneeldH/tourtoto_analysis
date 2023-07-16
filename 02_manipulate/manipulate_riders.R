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

## xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
### 2.1 Fix horse / multiplier ####
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


## xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
## 2.2 Add other stuff

riders <- riders %>%
  ## add year category
  mutate(year_horse = if_else(year_int >= 2020, TRUE, FALSE),
         year_simple = if_else(year_int %in% c(2018, 2019), TRUE, FALSE),
         year_trui = if_else(year_int <= 2017, TRUE, FALSE))  %>%
  ## fix uitgevallen, this is differently encoded in 2011 / 2012
  mutate(
    Uitgevallen_etappe = case_when(
      year_int %in% c(2011, 2012) ~ Uitgevallen,
      .default = NA_integer_),
    Uitgevallen = case_when(
      year_int %in% c(2011, 2012) ~ Uitgevallen > 0,
      .default = Uitgevallen)
    )







## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  riders,
  "data/02_manipulated/RID_riders.rds"
)

clear_script_objects()
