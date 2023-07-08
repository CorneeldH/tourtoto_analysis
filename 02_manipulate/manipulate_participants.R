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

participants_df <- read_rds("C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/01_validated/PAR_participants.rds")


## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 2. MODIFY ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Pas kolomnamen aan met behulp van de documentatie

## standardize names so it can easily be pivoted later
participants_df <- participants_df %>%
  rename(StandDagEind = StandEind,
         PuntenEEind = PuntenEind)

## TODO make stand cols for pnt_ cols

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## SAVE & CLEAN ####
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

write_rds(
  participants_df,
  "C:/Users/user/Dropbox/Programming/Tourtoto/overig/data/02_manipulated/PAR_participants.rds"
)

clear_script_objects()
