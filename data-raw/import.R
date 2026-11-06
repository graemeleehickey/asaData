# Recreate all packaged data from the pinned source files.
# Run from the package repository root: source("data-raw/import.R").
local({
  stopifnot(file.exists("DESCRIPTION"), dir.exists("data-raw"))
  manifest <- read.csv("inst/extdata/manifest.csv", stringsAsFactors = FALSE)
  schema <- read.csv("inst/extdata/schema.csv", stringsAsFactors = FALSE)
  selected <- manifest$dataset[manifest$import]
  stopifnot(!anyNA(manifest$import), !anyDuplicated(selected),
            setequal(selected, manifest$dataset))
  old_locale <- Sys.getlocale("LC_TIME")
  on.exit(Sys.setlocale("LC_TIME", old_locale), add = TRUE)
  if (is.na(Sys.setlocale("LC_TIME", "C"))) stop("Cannot select English month names.")
  dir.create("data", showWarnings = FALSE)

  for (i in seq_len(nrow(manifest))) {
    m <- manifest[i, ]
    s <- schema[schema$dataset == m$dataset, ]
    files <- file.path("inst", "extdata", c(m$data_file, m$codebook))
    expected_md5 <- c(m$data_md5, m$codebook_md5)
    if (!identical(unname(tools::md5sum(files)), expected_md5)) {
      stop("Source checksum differs from the pinned version: ", m$dataset)
    }
    if (!m$import) next
    raw <- read.table(files[1L], header = FALSE, colClasses = "character",
                      na.strings = ".", quote = "", comment.char = "",
                      col.names = s$variable, check.names = FALSE)
    stopifnot(nrow(raw) == m$rows, ncol(raw) == m$columns,
              identical(as.integer(colSums(is.na(raw))), as.integer(s$missing)))
    result <- raw
    for (j in seq_len(nrow(s))) {
      if (s$storage[j] == "Date") {
        parsed <- as.Date(raw[[j]], format = s$date_format[j])
        if (!identical(is.na(parsed), is.na(raw[[j]])) ||
            !all(tolower(format(parsed, s$date_format[j])) == tolower(raw[[j]]), na.rm = TRUE)) {
          stop("Date conversion failed: ", m$dataset, "$", s$variable[j])
        }
      } else {
        parsed <- as.numeric(raw[[j]])
        stopifnot(identical(is.na(parsed), is.na(raw[[j]])))
        if (s$storage[j] == "integer") {
          stopifnot(all(parsed == trunc(parsed), na.rm = TRUE))
          parsed <- as.integer(parsed)
        }
      }
      result[[j]] <- parsed
    }
    e <- new.env(parent = emptyenv())
    assign(m$dataset, result, envir = e)
    save(list = m$dataset, envir = e, file = file.path("data", paste0(m$dataset, ".rda")),
         compress = "xz", version = 2)
    message(m$dataset, ": ", nrow(result), " rows, ", ncol(result), " variables")
  }
})
