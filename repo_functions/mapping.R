map_num_to_cat <- function (Data, current, new, mapping_table_input = NULL, mapping_table_naam = NULL,
                            KeepOriginal = TRUE)
{
  Data$CURRENT <- Data[, current]
  Data$CURRENT <- unlist(Data$CURRENT)
  Data$CURRENT <- as.numeric(Data$CURRENT)
  if (!is.null(mapping_table_input)) {
    categories <- mapping_table_input
  }
  else if (!is.null(mapping_table_naam)) {
    categories <- utils::read.csv2(paste0("metadata/mapping_tables/",
                                          mapping_table_naam))
  }
  else {
    categories <- utils::read.csv2(paste0("metadata/mapping_tables/",
                                          current, "_TO_", new, ".csv", sep = ""))
  }
  boundaries <- append(categories$lower, utils::tail(categories$upper,
                                                     n = 1))
  Data$TO <- cut(Data$CURRENT, boundaries, categories$category,
                 right = F)
  colnames(Data)[which(names(Data) == "TO")] <- new
  Data$CURRENT <- NULL
  return(Data)
}

map_num_to_num <- function (Data, current, new, mapping_table_input = NULL, mapping_table_naam = NULL,
                            KeepOriginal = TRUE)
{
  Data$CURRENT <- Data[, current]
  Data$CURRENT <- unlist(Data$CURRENT)
  Data$CURRENT <- as.numeric(Data$CURRENT)
  if (!is.null(mapping_table_input)) {
    translate <- mapping_table_input
  }
  else if (!is.null(mapping_table_naam)) {
    translate <- utils::read.csv2(paste0("metadata/mapping_tables/",
                                          mapping_table_naam))
  }
  else {
    translate <- utils::read.csv2(paste0("metadata/mapping_tables/",
                                          current, "_TO_", new, ".csv", sep = ""))
  }
  boundaries <- append(translate$lower, utils::tail(translate$upper,
                                                     n = 1))
  Data$TO <- cut(Data$CURRENT, boundaries, translate$numeric,
                 right = F)

  #Data$TO <- translate$to[match(Data$CURRENT, translate$from)]
  if (!KeepOriginal) {
    Data <- Data[, !names(Data) %in% c(current)]
  }

  Data$TO <- as.numeric(Data$TO)

  if (new %in% colnames(Data)) {
    stop("the specified new column name already exists in the specified dataframe")
  }

  colnames(Data)[which(names(Data) == "TO")] <- new
  Data$CURRENT <- NULL
  return(Data)

}


map_cat_to_num <- function (Data, current, new, mapping_table_input = NULL, mapping_table_name = NULL,
          KeepOriginal = TRUE)
{
  Data$CURRENT <- Data[, current]
  Data$CURRENT <- unlist(Data$CURRENT)
  Data$CURRENT <- as.character(Data$CURRENT)

  if (!is.null(mapping_table_input)) {
    if (!(any(names(mapping_table_input) == "from") && any(names(mapping_table_input) ==
                                                           "to"))) {
      stop("mapping_table must contain the columns 'from' and 'to'.")
    }
  }
  if (!is.null(mapping_table_input)) {
    translate <- mapping_table_input
  }
  else if (!is.null(mapping_table_name)) {
    translate <- utils::read.csv2(paste0("metadata/mapping_tables/",
                                         mapping_table_name), stringsAsFactors = F)
  }
  else {
    translate <- utils::read.csv2(paste0("metadata/mapping_tables/",
                                         current, "_TO_", new, ".csv", sep = ""),
                                  stringsAsFactors = F)
  }

  Data$TO <- translate$to[match(Data$CURRENT, translate$from)]
  if (!KeepOriginal) {
    Data <- Data[, !names(Data) %in% c(current)]
  }

  Data$TO <- as.numeric(Data$TO)

  if (new %in% colnames(Data)) {
    stop("the specified new column name already exists in the specified dataframe")
  }
  colnames(Data)[which(names(Data) == "TO")] <- new
  Data$CURRENT <- NULL
  return(Data)
}

