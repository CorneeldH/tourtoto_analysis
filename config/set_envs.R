

set_all_envs <- function(var.name, var.value) {
  args = list(var.value)
  names(args) = var.name
  do.call(Sys.setenv, args)
}

## Lees in systeemvariabelen excel bestand
to_set <- read_delim("config/renviron.csv")



named_list <- set_names(to_set$value, to_set$variable)

to_set <- to_set %>%
  mutate(value = if_else(str_detect(variable, "DATA") & variable != "DATA_BASE_DIR",
                         paste0(named_list["DATA_BASE_DIR"], value)))


## zet variabelen in R system variables
pwalk(list(to_set$variable, to_set$value), set_all_envs)
Sys.getenv(Sys.getenv("DATA_BASE_DIR"))
