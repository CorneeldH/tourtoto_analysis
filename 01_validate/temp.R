

Sys.setenv(load_and_save_config = "config/load_and_save_settings.csv")

load_and_save_config <- function() {
  load_and_save_config <- Sys.getenv("load_and_save_config")
  if (load_and_save_config == "") {
    rlang::warn("You have not set a save directory", .frequency = "always", .frequency_id = "load_and_save_config")

  } else {
    load_and_save_config <- read_delim(load_and_save_config)

  }

  return(load_and_save_config)

}

test <- load_and_save_config()

save_proj <- function(object, name, dir = load_and_save_config()) {
  if (Sys.getenv("RSTUDIO") == "1") {
    docname <- basename(rstudioapi::getActiveDocumentContext()$path)
    directory <- rstudioapi::getActiveDocumentContext()$path
  }
  else {
    docname <- basename(scriptName::current_filename())
    directory <- this.path::this.dir()
  }

  if (sum(str_detect(attr(test, "class"), "data.frame")) == 1) {
    dir_df <- dir %>%
      filter(str_detect(directory, script_dir))
    dir <-  paste(test2[["base_data_dir"]], test2[["save_data_dir"]], sep = "/")
  }

  save_dir_name <- paste(dir, name, sep = "/")


  if (!save_fst & !save_rds & !save_csv) {
    stop("No file extension has been provided")
  }

  if (save_csv) {
    data.table::fwrite(Object_to_save,
                       paste0(save_name, ".csv"),
                       row.names = show_rownames,
                       na = "",
                       sep = ";",
                       dec = ","
    )
  }

  if (save_fst) {
    fst::write_fst(Object_to_save,
                   paste0(save_name, ".csv"),
                   compress = 100)
  }
  if (save_rds) {
    saveRDS(Object_to_save,
            paste0(save_name,".csv"),
            version = 2)
  }
}
