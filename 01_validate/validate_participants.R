## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
##' *INFO*
## 1.
##
## TODO
## 1. Fix column names
##
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 1. LOAD ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

files_participants_chr <- c(
  ## Aanmeldingen
  list.files(
    "data/00_raw",
    full.names = TRUE,
    ## Een reguliere expressie waarin gezocht wordt naar:
    pattern = "deelnemers"
  )
)

years_participants_int <- as.numeric(str_extract(files_participants_chr, "([0-9]+)(?=[^/]*$)"))

participants_df <- files_participants_chr %>%
  map(read_csv) %>%
  map2(years_participants_int, ~ mutate(.x, year_int = .y) %>%
         mutate(across(starts_with("Stand"), ~as.integer(.)))) %>%
  reduce(bind_rows)


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. MODIFY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Pas kolomnamen aan met behulp van de documentatie
#Dataset <- Dataset %>% wrapper_translate_colnames_documentation(Dataset_naming)

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  participants_df,
  "data/01_validated/PAR_participants.rds"
)

clear_script_objects()
