# Check all 16 downloads using artificial records and local archive transfers.
library(asaData)
local({
  expect_error <- function(expr, pattern) {
    error <- tryCatch({ force(expr); NULL }, error = identity)
    stopifnot(inherits(error, "error"), grepl(pattern, conditionMessage(error), fixed = TRUE))
  }
  expect_error(download_asa_all(cache_dir = ""), "'cache_dir'")
  expect_error(download_asa_all(refresh = NA), "'refresh'")
  expect_error(download_asa_all(quiet = 1), "'quiet'")
  expect_error(download_asa_all(source = "ucla"), "'arg'")
  if (!nzchar(Sys.which(Sys.getenv("R_ZIPCMD", "zip")))) {
    message("Archive tests skipped: the standard zip utility is unavailable.")
    return(invisible(NULL))
  }
  scratch <- tempfile("asa-all-")
  dir.create(scratch)
  on.exit(unlink(scratch, recursive = TRUE), add = TRUE)
  previous_locale <- Sys.getlocale("LC_TIME")
  on.exit(Sys.setlocale("LC_TIME", previous_locale), add = TRUE)
  Sys.setlocale("LC_TIME", "C")
  fixture <- new.env(parent = asNamespace("asaData"))
  functions <- c("asa_datasets", "download_asa_all",
                 ls(asNamespace("asaData"), pattern = "^\\.asa_", all.names = TRUE))
  for (name in functions) {
    fn <- get(name, asNamespace("asaData"))
    environment(fn) <- fixture
    fixture[[name]] <- fn
  }
  manifest <- asa_datasets()
  schema <- read.csv(system.file("metadata", "schema.csv", package = "asaData"),
                     stringsAsFactors = FALSE)
  expected <- setNames(vector("list", nrow(manifest)), manifest$dataset)
  for (edition in 1:2) dir.create(file.path(scratch, paste0("edition", edition)))
  for (i in seq_len(nrow(manifest))) {
    columns <- schema[schema$dataset == manifest$dataset[i], ]
    manifest$rows[i] <- max(columns$missing) + 2L
    raw <- matrix("1", nrow = manifest$rows[i], ncol = nrow(columns))
    for (j in seq_len(nrow(columns))) {
      if (columns$storage[j] == "double") raw[, j] <- "1.25"
      if (columns$storage[j] == "Date") {
        raw[, j] <- format(as.Date("2000-01-01"), columns$date_format[j])
      }
      if (columns$missing[j]) raw[seq_len(columns$missing[j]), j] <- "."
    }
    file <- file.path(scratch, paste0("edition", manifest$edition[i]), manifest$file[i])
    write.table(raw, file, row.names = FALSE, col.names = FALSE, quote = FALSE)
    manifest$md5[i] <- unname(tools::md5sum(file))
    manifest$first_edition_md5[i] <- ""
    expected[[i]] <- fixture$.asa_read_file(file, manifest[i, ])
  }
  archives <- setNames(file.path(scratch, paste0("edition", 1:2, ".zip")), unique(manifest$url))
  for (i in 1:2) {
    files <- list.files(file.path(scratch, paste0("edition", i)), full.names = TRUE)
    utils::zip(archives[i], files = files, flags = "-j -q")
  }
  # Fallback transfer handling is checked below with a stand-in SPSS reader.
  archives[unique(manifest$ucla_url[nzchar(manifest$ucla_url)])] <- archives[2L]
  fixture$manifest <- manifest
  fixture$asa_datasets <- eval(quote(function() manifest), fixture)
  fixture$archives <- archives
  fixture$calls <- character()
  fixture$fail_url <- ""
  fixture$.asa_fetch <- eval(quote(function(url, destination, quiet) {
    calls <<- c(calls, url)
    if (url == fail_url) stop("Simulated transfer failure.")
    stopifnot(file.copy(archives[[url]], destination, overwrite = TRUE))
  }), fixture)
  cache <- file.path(scratch, "cache")
  stopifnot(identical(fixture$download_asa_all(cache), expected),
            identical(fixture$calls, unique(manifest$url)),
            identical(list.files(cache), c("edition1.zip", "edition2.zip")))
  fixture$calls <- character()
  stopifnot(identical(fixture$download_asa_all(cache), expected), !length(fixture$calls))
  stopifnot(identical(fixture$download_asa_all(cache, refresh = TRUE), expected),
            identical(fixture$calls, unique(manifest$url)))

  # A failed refresh must not return a partial list or quietly use old data.
  previous <- tools::md5sum(file.path(cache, "edition2.zip"))
  fixture$fail_url <- manifest$url[manifest$dataset == "actg320"]
  unchanged <- "previous result"
  expect_error(unchanged <- fixture$download_asa_all(cache, refresh = TRUE), "failed at 'actg320'")
  stopifnot(identical(unchanged, "previous result"),
            identical(previous, tools::md5sum(file.path(cache, "edition2.zip"))),
            identical(list.files(cache), c("edition1.zip", "edition2.zip")))

  # Two rejected Wiley datasets share one UCLA transfer, including on refresh.
  fixture$fail_url <- ""
  fixture$expected <- expected
  fixture$original_reader <- fixture$.asa_read_archive
  fixture$.asa_read_archive <- eval(quote(function(archive, metadata, source = "auto") {
    if (source == "wiley" && metadata$dataset %in% c("bpd", "gbcs")) {
      stop("Simulated rejected Wiley dataset.")
    }
    if (source == "ucla") return(expected[[metadata$dataset]])
    original_reader(archive, metadata, source)
  }), fixture)
  for (refresh in c(FALSE, TRUE)) {
    fixture$calls <- character()
    stopifnot(identical(suppressMessages(fixture$download_asa_all(cache, refresh = refresh)), expected))
    wanted <- if (refresh) c(unique(manifest$url), unique(manifest$ucla_url[nzchar(manifest$ucla_url)])) else {
      unique(manifest$ucla_url[nzchar(manifest$ucla_url)])
    }
    stopifnot(identical(fixture$calls, wanted))
  }
  fixture$calls <- character()
  expect_error(fixture$download_asa_all(cache, source = "wiley"), "failed at 'bpd'")
  stopifnot(!length(fixture$calls))
  cat("All-dataset downloads, archive reuse, refresh, fallback, and complete-result checks passed.\n")
})
