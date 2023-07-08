

folders <- list.files(pattern = "^0", full.names = TRUE)

walk(folders, ~list.files(., full.names = TRUE) %>% walk(source))

