


# Function to export table to CSV
exportTableToCSV <- function(con, table_name, csv_name) {
  query <- paste0("SELECT * FROM ", table_name)
  table_data <- dbGetQuery(con, query)
  write_csv(table_data, csv_name)
}

# Create a list of years
years <- 2011:2022

# Loop through the databases and export tables
for (year in years) {
  # Create the database name
  db_name <- paste0("tourtoto", year)

  # Create the connection
  con <- dbConnect(MySQL(),
                   user = db_user,
                   password = db_pass,
                   dbname = db_name,
                   host = db_host,
                   port = db_port)

  # Check if the connection is successful
  if (dbIsValid(con)) {
    print(paste0("Connected to ", db_name))

    # # Export tt_deelnemers table
    # exportTableToCSV(con, "tt_deelnemers", paste0("data/00_raw/", year, "_deelnemers.csv"))
    #
    # # Export tt_renners table
    # exportTableToCSV(con, "tt_renners", paste0("data/00_raw/", year, "_renners.csv"))
    #
    # # Export tt_eind table
    # exportTableToCSV(con, "tt_eind", paste0("data/00_raw/", year, "_renner_eind.csv"))
    #
    # # Export tt_stages table
    # exportTableToCSV(con, "tt_etappes", paste0("data/00_raw/", year, "_renner_etappes.csv"))

    if (year <= 2016) {
      exportTableToCSV(con, "tt_ploegen", paste0("data/00_raw/", year, "_ploegen.csv"))
      exportTableToCSV(con, "tt_dagploeg", paste0("data/00_raw/", year, "_ploeg_etappes.csv"))
    }

    if (year <= 2017) {
      exportTableToCSV(con, "tt_bol", paste0("data/00_raw/", year, "_renner_bol.csv"))
      exportTableToCSV(con, "tt_geel", paste0("data/00_raw/", year, "_renner_geel.csv"))
      exportTableToCSV(con, "tt_groen", paste0("data/00_raw/", year, "_renner_groen.csv"))
    }

    if (year == 2017) {
      exportTableToCSV(con, "tt_wit", paste0("data/00_raw/", year, "_renner_wit.csv"))
    }

    # Close the connection
    dbDisconnect(con)
  } else {
    print(paste0("Connection to ", db_name, " failed."))
  }
}
