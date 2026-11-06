# Check UCLA conversions using artificial records, with optional real-file comparisons.
library(asaData)
local({
  manifest <- asa_datasets()
  schema <- read.csv(system.file("metadata", "schema.csv", package = "asaData"),
                     stringsAsFactors = FALSE)
  normalize <- getFromNamespace(".asa_normalize_spss", "asaData")
  convert <- getFromNamespace(".asa_convert", "asaData")
  for (name in c("uis", "gbcs", "whas100", "whas500")) {
    metadata <- manifest[manifest$dataset == name, ]
    columns <- schema[schema$dataset == name, ]
    metadata$rows <- max(columns$missing) + 2L
    expected <- as.data.frame(setNames(lapply(seq_len(nrow(columns)), function(j) {
      value <- if (columns$storage[j] == "Date") {
        as.Date("2000-01-01") + seq_len(metadata$rows) - 1L
      } else if (columns$storage[j] == "integer") {
        seq_len(metadata$rows)
      } else rep(12.345, metadata$rows)
      if (columns$missing[j]) value[seq_len(columns$missing[j])] <- NA
      value
    }), columns$variable))
    raw <- expected
    for (variable in columns$variable[columns$storage == "Date"]) {
      raw[[variable]] <- if (name == "whas100") {
        paste0(format(raw[[variable]], "%m/%d/%y"), " ")
      } else as.numeric(raw[[variable]] - as.Date("1582-10-14")) * 86400
    }
    if (name == "uis") {
      raw$beck <- raw$beck + 0.000001
      names(raw)[names(raw) == "beck"] <- "becktota"
      names(raw)[names(raw) == "id"] <- "ID"
    }
    if (name %in% c("whas100", "whas500")) raw$bmi <- raw$bmi + 0.000001
    if (name == "whas100") {
      rename <- c(admitdate = "addate", los = "hosstay", lenfol = "foltime",
                  fstat = "folstatus")
      selected <- names(raw) %in% names(rename)
      names(raw)[selected] <- unname(rename[names(raw)[selected]])
      raw <- raw[rev(seq_len(nrow(raw))), ]
    }
    locale <- Sys.getlocale("LC_TIME")
    actual <- convert(normalize(raw, metadata, columns), metadata, columns)
    stopifnot(identical(actual, expected), identical(Sys.getlocale("LC_TIME"), locale))
  }
  cat("Synthetic UCLA name, date, precision, missing-value, and row-order checks passed.\n")
})

if (nzchar(Sys.getenv("ASADATA_TEST_ARCHIVES"))) local({
  folder <- Sys.getenv("ASADATA_TEST_ARCHIVES")
  paths <- file.path(folder, paste0("edition", 1:2, ".zip"))
  all_data <- read_asa_all(paths)
  manifest <- asa_datasets()
  stopifnot(identical(names(all_data), manifest$dataset),
            length(read_asa_all(paths[1L])) == 5L,
            length(read_asa_all(paths[2L])) == 13L)
  for (name in names(all_data)) {
    stopifnot(identical(all_data[[name]], download_asa(name, folder, source = "wiley")))
  }
  # Both editions' shared files must return identical values and types.
  for (name in c("recur", "uis")) {
    stopifnot(identical(read_asa(name, paths[1L]), read_asa(name, paths[2L])))
  }
  ucla <- Sys.getenv("ASADATA_TEST_UCLA_ARCHIVE")
  if (nzchar(ucla)) {
    alternatives <- read_asa_all(ucla)
    stopifnot(identical(names(alternatives), manifest$dataset[nzchar(manifest$ucla_file)]))
    for (name in names(alternatives)) {
      stopifnot(identical(alternatives[[name]], all_data[[name]]),
                identical(read_asa(name, ucla), all_data[[name]]))
    }
    cat("All six UCLA imports exactly match their Wiley counterparts.\n")
  }
  cat("Batch imports and both editions' shared files passed comparison checks.\n")
})
