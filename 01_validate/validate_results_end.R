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

files_results_end_chr <- c(
  ## Aanmeldingen
  list.files(
    "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/00_raw",
    full.names = TRUE,
    ## Een reguliere expressie waarin gezocht wordt naar:
    pattern = "renner_eind"
  )
)

years_results_end_int <- as.numeric(str_extract(files_results_end_chr, "([0-9]+)(?=[^/]*$)"))

results_end_df <- files_results_end_chr %>%
  map(read_csv) %>%
  map2(years_results_end_int, ~ mutate(.x, year_int = .y) %>%
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
  results_end_df,
  "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/01_validated/RID_results_end.rds"
)

clear_script_objects()
