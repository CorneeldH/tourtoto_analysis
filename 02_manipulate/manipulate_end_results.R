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

end_results_df <- read_rds("C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/01_validated/RID_end_results.rds")


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. MODIFY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Pas kolomnamen aan met behulp van de documentatie
yellow <- end_results_df %>%
  select(starts_with("Geel"), year_int) %>%
  pivot_longer(starts_with("Geel"),
               names_to = "positie",
               values_to = "rennerID"
  )


# test <- end_results_df %>%
#   select(-starts_with("Ploeg")) %>%
#   pivot_longer(
#     cols = matches("[A-Za-z]\\d{1,2}$"),
#     names_to = c(".value", "position"),
#     names_pattern = "([A-Za-z]+)(\\d+)$"
#   )


test2 <- end_results_df %>%
  pivot_longer(
    cols = -c(year_int),
    names_to = "type",
    values_to = "renner_ID"
  )

%>%
  mutate(
    renner_ID = value,
    position = as.integer(position)
  ) %>%
  select(-value) %>%
  pivot_wider(
    names_from = name,
    values_from = renner_ID
  )


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  end_results_df,
  "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/02_manipulated/RID_end_results.rds"
)

clear_script_objects()
