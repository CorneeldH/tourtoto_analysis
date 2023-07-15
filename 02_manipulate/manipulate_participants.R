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

participants_df <- read_rds("data/01_validated/PAR_participants.rds")


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. MODIFY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


participants_df <- participants_df %>%
  ## TODO Ugly fix: Names mapping table van maken oid
  mutate(Eigenaar = if_else(Eigenaar == "Alexander" & str_detect(email, "wisse"), "Alexander Wisse", Eigenaar),
         Eigenaar = if_else(Eigenaar == "Yvonne", "Yvonne Rouwhorst", Eigenaar)) %>%
  ## Correct for second teams
  group_by(Eigenaar, year_int) %>%
  arrange(desc(Punten)) %>%
  mutate(Eigenaar = if_else(row_number() > 1, paste(Eigenaar, "(2)"), Eigenaar)
  ) %>%
  select(Eigenaar, everything()) %>%
  ungroup() %>%
  arrange(year_int) %>%
  ## standardize names so it can easily be pivoted later
  rename(StandDagEind = StandEind,
         PuntenEEind = PuntenEind) %>%
  ## add year category
  mutate(year_horse = if_else(year_int >= 2020, TRUE, FALSE),
         year_simple = if_else(year_int %in% c(2018, 2019), TRUE, FALSE),
         year_trui = if_else(year_int <= 2017, TRUE, FALSE)) %>%
  ## add ranking
  group_by(year_int) %>%
  arrange(desc(Punten)) %>%
  mutate(ranking = 1 - row_number() / n()) %>%
  ungroup() %>%
  group_by(Eigenaar) %>%
  arrange(year_int) %>%
  mutate(ranking_average = mean(ranking),
         ranking_average_without_current = (sum(ranking) - ranking) / (n() - 1),
         ranking_average_historical = cumsum(ifelse(is.na(ranking), 0, ranking)) / cumsum(!is.na(ranking)),
         ranking_average_horse = sum(ranking * year_horse) / sum(year_horse),
         ranking_average_trui = sum(ranking * year_trui) / sum(year_trui),
         ranking_average_simple = sum(ranking * year_simple) / sum(year_simple),
         ranking_average_horse_without_current = (sum(ranking * year_horse) - (ranking * year_horse)) / (sum(year_horse) - year_horse),
         ranking_average_trui_without_current = (sum(ranking * year_trui) - (ranking * year_trui)) / (sum(year_trui) - year_trui),
         ranking_average_simple_without_current = (sum(ranking * year_simple) - (ranking * year_simple)) / (sum(year_simple) - year_simple),
         participation_number = row_number(),
         participation_first_time = participation_number == 1
  ) %>% ungroup()

#participants_df2 <- participants_df %>%




test <- participants_df %>%
  #group_by(Eigenaar) %>%
  #filter(year_int == max(year_int), participation_number > 1) %>%
  select(
    Eigenaar,
    year_int,
    starts_with("participation"),
    starts_with("ranking"),
    everything()
  )

test <- participants_df %>%
  filter(Eigenaar %in% c("Corneel den Hartogh")) %>% #, "Yvonne Rouwhorst")) %>%
  select(
    Eigenaar,
    year_int,
    starts_with("ranking"),
    everything()
  ) %>%
  arrange(year_int)

## TODO make stand cols for pnt_ cols

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  participants_df,
  "data/02_manipulated/PAR_participants.rds"
)

clear_script_objects()
