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

files_stage_results_chr <- c(
  ## Aanmeldingen
  list.files(
    "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/00_raw",
    full.names = TRUE,
    ## Een reguliere expressie waarin gezocht wordt naar:
    pattern = "renner_etappes"
  )
)

years_stage_results_int <- as.numeric(str_extract(files_stage_results_chr, "([0-9]+)(?=[^/]*$)"))

stage_results_df <- files_stage_results_chr %>%
  map(read_csv) %>%
  map2(years_stage_results_int, ~ mutate(.x, year_int = .y) %>%
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
  stage_results_df,
  "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/01_validated/RID_stage_results.rds"
)

clear_script_objects()
