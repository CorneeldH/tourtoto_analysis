
packages_base <- c(
    "base",
    "methods",
    "utils",
    "stats",
    "graphics",
    "grDevices",
    "datasets")

packages_cran_with_version <- c(
    ## Reverse order of importance

    ## TODO see in download what is really needed
    ## database
    "DBI",
    "RMySQL",
    "dbplyr",

    ## specifiek voor modellen
    "poissonreg",
    #"rstanarm", ## Interessant komt uit Statistical Rehtinking (McElreath), installeert wel veel andere modellen
    "glmnet",
    "ranger",
    "bonsai",
    "partykit",
    "baguette",
    "xgboost",
    "dbarts",

    ## model controle
    "DALEXtra",

    ## shiny / visualization
    "ggplot2",
    "shiny",
    "shinyWidgets",
    "plotly",
    "shinythemes",
    "shinydashboard",
    "shinydashboardPlus",
    "scales",
    "skimr",
    "DT",

    ## tidy modelling
    "broom",
    "recipes",
    "dials",
    "rsample",
    "tune",
    "modeldata",
    "workflows",
    "parsnip",
    "workflowsets",
    "yardstick",
    "themis",
    "usemodels",

    ## data prep
    ## TODO: Due to close_view() this should be version 0.13
    "rstudioapi",
    #"this.path@0.8.0"
    "fuzzyjoin",
    "rvest",
    "janitor",
    "tibble",

    "tidyr",
    "lubridate",
    "stringi",
    "stringr",
    "stringdist",

    ## very important
    "readr",
    "renv",
    "devtools",
    "purrr",
    "dplyr"

    )


packages_vusaverse <-c(
    "vvcommander",
    ## TODO: tijdelijk uitgeschakeld
    "vvmover",
    "vvmodeller",
    "vvconverter",
    "vvsculptor",
    "vvauditor",
    "vvfiller",
    "vusa"
    )
#
# packages_github_with_repo <- c(
#     "MichelNivard/gptstudio",
#     "JamesHWade/gpttools"
# )


## Update vusaverse packages only
## INFO: Renv::update only works for cran packages
# purrr::walk(packages_vusaverse,
#             ~ ifelse(. == "vusa",
#                      renv::update(paste0("bitbucket::vustudentanalytics/", .)),
#                      renv::update(paste0("bitbucket::vustudentanalytics/", ., "@main"))
#             ))

## TODO: Run code for cran and github packages update
## Include config, special case since it should be loaded
# purrr::walk(
#   c(packages_cran_with_version, config),
#   ~renv::update(.)
#   )


## Remove account and keep only repository for loading
# packages_github <- purrr::map_chr(
#     packages_github_with_repo,
#     ~stringr::str_split(., "/")[[1]][[2]])


## Remove versions and keep only package name for loading
packages_cran <- purrr::map_chr(
    packages_cran_with_version,
    ~stringr::str_split(., "@")[[1]][[1]])

## Load packages
packages <- c(packages_base, packages_cran, packages_vusaverse) #, packages_github)
purrr::walk(packages, ~library(., character.only = TRUE))

## Add custom function for retrieving packages for renv (only the above)
options(renv.snapshot.filter = function(project) {
    return(packages)
})

## Update renv.lock with argument packages to also get dependencies
## TODO: When updating all packages enable prompt
#renv::snapshot(packages = packages, prompt = FALSE)

function_files <- list.files("config/repo_functions", full.names = TRUE)

walk(function_files, source)

###
## ruim op
###

clear_script_objects()

