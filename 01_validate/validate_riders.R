## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
##' *INFO*
## 1)
##
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. LOAD ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

files_riders_chr <- c(
  ## Aanmeldingen
  list.files(
    "data/00_raw",
    full.names = TRUE,
    ## Een reguliere expressie waarin gezocht wordt naar:
    pattern = "renners"
  )
)

years_riders_int <- as.numeric(str_extract(files_riders_chr, "([0-9]+)(?=[^/]*$)"))

riders_df <- files_riders_chr %>%
  map(read_csv) %>%
  map2(years_riders_int, ~ mutate(.x, year_int = .y)) %>%
  reduce(bind_rows) %>%
  mutate(Rugnummer = coalesce(Rugnummer, RN)) %>%
  select(-RN)


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. MODIFY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Pas kolomnamen aan met behulp van de documentatie
#Dataset <- Dataset %>% wrapper_translate_colnames_documentation(Dataset_naming)

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  riders_df,
  "data/01_validated/RID_riders.rds"
)

clear_script_objects()

