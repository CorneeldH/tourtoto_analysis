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


participants_df2 <- participants_df %>%
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
         year_trui = if_else(year_int <= 2017, TRUE, FALSE),
         year_type = case_when(
           year_int >= 2020 ~ "horses",
           year_int %in% c(2018, 2019) ~ "simple",
           year_int <= 2017 ~ "trui"
         )) %>%
  ## add ranking
  group_by(year_int) %>%
  arrange(desc(Punten)) %>%
  mutate(ranking = 1 - row_number() / n()) %>%
  ungroup() %>%
  group_by(Eigenaar) %>%
  arrange(year_int) %>%
  mutate(ranking_average = mean(ranking),
         ranking_variance = var(ranking),
         ranking_average_without_current = (sum(ranking) - ranking) / (n() - 1),
         ranking_average_historical = cumsum(ifelse(is.na(ranking), 0, ranking)) / cumsum(!is.na(ranking)),
         participation_number = row_number(),
         participation_first_time = participation_number == 1
  ) %>%
  ungroup() %>%
  group_by(Eigenaar, year_type) %>%
  mutate(ranking_average_type = mean(ranking),
         ranking_average_type_without_current = (sum(ranking) - ranking) / (n() -1),
  ) %>%
  ungroup() %>%
  mutate(ranking_year_compare_var = if_else(year_int %in% c(2016, 2017, # last two years trui
                                                    2018, 2019, # two years simple
                                                    2021, 2022), # last two years horse
                                    TRUE,
                                    FALSE)
  ) %>%
  group_by(Eigenaar, year_type, ranking_year_compare_var) %>%
  mutate(ranking_var_by_type = if_else(n() > 1, var(ranking), NA),
         ranking_cor_by_type = min(ranking), max(ranking), use = "complete.obs") %>%
  ungroup()

#participants_df2 <- participants_df %>%

test3 <- participants_df2 %>%
  filter(ranking_year_compare_var == TRUE) %>%
  group_by(year_type) %>%
  summarize(var = mean(ranking_var_by_type, na.rm = TRUE),
            cor = mean(ranking_cor_by_type, na.rm = TRUE))


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

test <- participants_df2 %>%
  filter(Eigenaar %in% c("Corneel den Hartogh")) %>% #, "Yvonne Rouwhorst")) %>%
  select(
    Eigenaar,
    year_int,
    starts_with("ranking"),
    everything()
  ) %>%
  arrange(year_int)

test_old <- participants_df_old %>%
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
