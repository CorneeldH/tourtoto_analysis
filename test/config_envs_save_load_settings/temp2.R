


load_and_save_config_proj <- function() {
  load_and_save_config_path <- Sys.getenv("load_and_save_config")

  supported_read_extensions <- c("rds", "csv", "fst")


  documentation_reference <- "See documentation at:\n https://r.mtdv.me/load_save_config."

  if (load_and_save_config_path == "") {
    rlang::warn("You have not set load and save settings", .frequency = "always", .frequency_id = "load_and_save_config_no_env_var")
    return(NULL)
  }

  tryCatch(
    error = function(e) {
      rlang::warn(paste0("Your load_and_save_config_path doesn't lead to a correct semicolon separated csv.\n",
                         documentation_reference,
      ),
      .frequency = "session",
      .frequency_id = "load_and_save_config_file_path")
      return(NULL)
    },
    load_and_save_config_df <- read_delim(load_and_save_config_path, sep = ";")
  )


  names_config <- c("script_dir", "load_data_dir", "save_data_dir", "base_data_dir", "add_branch", "save_csv", "save_rds", "save_fst", "read_extension", "notes")

  if (all(names(load_and_save_config_df) != names_config)) {
    rlang::warn(paste0("Your load and save settings are not as expected.\n",
                       documentation_reference),
                .frequency = "session",
                .frequency_id = "load_and_save_config_colnames")

    return(NULL)
  }

  if (unique(load_and_save_config_df$script_dir) != load_and_save_config_df$script_dir) {
    duplicated <- load_and_save_config_df$script_dir[duplicated(load_and_save_config_df$script_dir)]
    rlang::warn(paste0("The following directories appear more than once:\n",
                       duplicated,
                       "\n",
                       documentation_reference),
                .frequency = "always",
                .frequency_id = "load_and_save_config_duplicated")
    return(NULL)
  }

  script_dirs_without_save <- load_and_save_config_df %>%
    dplyr::mutate(save = purrr::pmap(list(save_rds, save_csv, save_fst), sum)) %>%
    dplyr::filter(save == 0) %>%
    dplyr::pull(script_dir)

  if (length(script_dirs_without_save > 0)) {
    rlang::warn(paste0("The following directories don't have any save_* argument on TRUE:\n",
                       script_dirs_without_save,
                       "\n",
                       documentation_reference),
                .frequency = "session",
                .frequency_id = "load_and_save_config_")
    return(NULL)

  }

  script_dirs_without_supported_read_extension <- load_and_save_config_df %>%
    dplyr::mutate(supported_extension = read_extension %in% read_extensions)  %>%
    dplyr::filter(supported_extension == FALSE) %>%
    dplyr::pull(script_dir)

  if (length(script_dirs_without_supported_read_extension > 0)) {
    rlang::warn(paste0("The following directories don't have a supported read extension:",
                       script_dirs_without_supported_read_extension,
                       "\n",
                       "Supported read extension are:",
                       supported_read_extensions,
                       "\n",
                       documentation_reference),
                .frequency = "always",
                .frequency_id = "load_and_save_config_duplicated")
    return(NULL)

  }


  return(load_and_save_config_df)

}



read_file_proj <- function(
    name,
    settings_df = load_and_save_config_proj(),
    dir = NULL,
    extension = NULL,
    fix_encoding = FALSE,
    encoding = "latin1",
    csv_readr_function_args = list(trim_ws = T,
                                   delim = ";",
                                   locale = readr::locale(decimal_mark = ",",
                                                          grouping_mark = ".")),
    ...
) {

  # Check the manual and config setting for completeness
  if (sum(!is.null(dir),!is.null(extension)) < 2) {
    manual_settings <- FALSE
  }

  if (is.null(settings_df)) {
    config_settings <- FALSE
  }

  if (!is.null(settings_df)) {
    settings_script_dir <- settings_df %>%
      dplyr::filter(stringr::str_detect(directory, script_dir))

    if (nrow(settings_script_dir) == 0) {
      config_settings <- FALSE
    }

  }

  if (sum(manual_settings, config_settings) == 0) {
    rlang::abort(paste0("You have not given enough variables to save the file properly.\n,
                          Either add a correct config with current directory in it or set at least
                          the dir and one of the save_* arguments"))
  }


  # Set full path for read
  if (is.null(dir)) {
    dir <-  paste(settings_script_dir[["base_data_dir"]], settings_script_dir[["save_data_dir"]], sep = "/")

    if (settings_script_dir[["add_branch"]] == TRUE) {
      branch <- system("git branch --show-current", intern = TRUE)
      dir <- paste(dir, branch, sep = "/")
    }
  }

  if (is.null(extension)) {
    extension <- settings_script_dir[["read_extension"]]
  }

  file_name <- paste(name, extension, sep = ".")
  full_path <- paste(dir, file_name, sep = "/")


  # read with function based on extension
  if (extension == "rds") {
    if (fix_encoding == TRUE) {
      df <- fixencoding(readRDS(full_path, ...), encoding)
      return(df)
    }
    else {
      df <- readRDS(full_path, ...)
      return(df)
    }
  }

  if (extension == "csv") {
    if (fix_encoding) {
      df <- fixencoding(readr::read_delim(file = full_path,
                                          csv_readr_function_args,
                                          ...),
                        encoding)
      return(df)
    }
    else {
      df <- readr::read_delim(file = full_path,
                              csv_readr_function_args,
                              ...)
      return(df)
    }

  }

  if (extension == "fst") {
    if (fix_encoding) {
      df <- fixencoding(fst::read_fst(full_path, ...) %>%
                          dplyr::mutate_if(is.character, .funs = function(x) {
                            return(`Encoding<-`(x, "UTF-8"))
                          }), encoding)
      return(df)
    }
    else {
      df <- fst::read_fst(full_path, ...) %>% dplyr::mutate_if(is.character,
                                                              .funs = function(x) {
                                                                return(`Encoding<-`(x, "UTF-8"))
                                                              })
      return(df)
    }
  }


}


write_file_proj <- function(
    object,
    name,
    settings_df = load_and_save_config_proj(),
    dir = NULL,
    save_rds = NULL,
    save_csv = NULL,
    save_fst = NULL,
    rds_version = 2,
    csv_na = "",
    csv_sep = ";",
    csv_dec = ",",
    fst_compress = 100,
    ...
) {


  if (Sys.getenv("RSTUDIO") == "1") {
    docname <- basename(rstudioapi::getActiveDocumentContext()$path)
    directory <- rstudioapi::getActiveDocumentContext()$path
  }
  else {
    docname <- basename(scriptName::current_filename())
    directory <- this.path::this.dir()
  }

  # Check the manual setting and config
  if (sum(!is.null(dir), max(!is.null(save_rds), !is.null(save_csv), !is.null(save_fst))) < 2) {
    manual_settings <- FALSE
  }

  if (is.null(settings_df)) {
    config_settings <- FALSE
  }

  if (!is.null(settings_df)) {
    settings_script_dir <- settings_df %>%
      filter(str_detect(directory, script_dir))

    if (nrow(settings_script_dir) == 0) {
      config_settings <- FALSE
    }

  }

  if (sum(manual_settings, config_settings) == 0) {
    rlang::abort(paste0("You have not given enough variables to save the file properly.\n,
                          Either add a correct config with current directory in it or set at least
                          the dir and one of the save_* arguments"))
  }


  # Set save variables
  if (is.null(dir)) {
    dir <-  paste(settings_script_dir[["base_data_dir"]], settings_script_dir[["save_data_dir"]], sep = "/")

    if (settings_script_dir[["add_branch"]] == TRUE) {
      branch <- system("git branch --show-current", intern = TRUE)
      dir <- paste(dir, branch, sep = "/")
    }
  }

  if (is.null(save_csv) && config_settings) {
    save_rds = settings_script_dir[["save_rds"]]
  } else{
    save_rds = FALSE
  }

  if (is.null(save_csv) && config_settings) {
    save_csv = settings_script_dir[["save_csv"]]
  } else{
    save_csv = FALSE
  }

  if (is.null(save_csv) && config_settings) {
    save_fst = settings_script_dir[["save_fst"]]
  } else{
    save_fst = FALSE
  }


  if (save_csv) {
    data.table::fwrite(object,
                       paste0(name, ".csv"),
                       na = csv_na,
                       sep = csv_sep,
                       dec = csv_dec
    )
  }

  if (save_fst) {
    fst::write_fst(object,
                   paste0(name, ".fst"),
                   compress = fst_compress,
                   ...)
  }

  if (save_rds) {
    saveRDS(object,
            paste0(name,".rds"),
            version = rds_version,
            ...)
  }
}

