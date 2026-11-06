# Exercise imports and download handling with synthetic records only.
library(asaData)
local({
  manifest <- asa_datasets()
  schema <- read.csv(system.file("metadata", "schema.csv", package = "asaData"),
                     stringsAsFactors = FALSE)
  stopifnot(nrow(manifest) == 16L, !anyDuplicated(manifest$dataset),
            nrow(schema) == 175L, setequal(manifest$dataset, schema$dataset),
            length(unique(manifest$url)) == 2L,
            sum(nzchar(manifest$ucla_url)) == 6L,
            sum(nzchar(manifest$first_edition_md5)) == 2L,
            all(startsWith(manifest$url, "https://ftp.wiley.com/")),
            identical(data(package = "asaData")$results, matrix(character(), 0L, 4L,
              dimnames = list(NULL, c("Package", "LibPath", "Item", "Title")))),
            !nzchar(system.file("extdata", package = "asaData")))
  # Every variable still has a help-page definition.
  rd <- tools::Rd_db("asaData")
  for (name in manifest$dataset) {
    format_section <- Filter(function(z) identical(attr(z, "Rd_tag"), "\\format"),
                             rd[[paste0(name, ".Rd")]])
    descriptions <- Filter(function(z) identical(attr(z, "Rd_tag"), "\\describe"),
                            format_section[[1L]])
    items <- Filter(function(z) identical(attr(z, "Rd_tag"), "\\item"), descriptions[[1L]])
    variables <- vapply(items, function(z) paste(unlist(z[[1L]]), collapse = ""), character(1))
    stopifnot(identical(variables, schema$variable[schema$dataset == name]))
  }
  expect_error <- function(expr, pattern) {
    error <- tryCatch({ force(expr); NULL }, error = identity)
    stopifnot(inherits(error, "error"), grepl(pattern, conditionMessage(error), fixed = TRUE))
  }
  for (name in list(NA_character_, character(), c("bpd", "uis"), "", 1)) {
    expect_error(download_asa(name), "'name'")
  }
  expect_error(download_asa("unknown"), "Unknown dataset")
  expect_error(download_asa("bpd", refresh = NA), "'refresh'")
  expect_error(download_asa("bpd", quiet = 1), "'quiet'")
  expect_error(download_asa("bpd", cache_dir = ""), "'cache_dir'")
  expect_error(read_asa("bpd", "file-that-does-not-exist.dat"), "does not exist")

  scratch <- tempfile("asa-test-")
  dir.create(scratch)
  on.exit(unlink(scratch, recursive = TRUE), add = TRUE)
  file <- file.path(scratch, "bpd.dat")
  writeLines(c("1 0 12 1", "2 1 20 0"), file, useBytes = TRUE)
  # Use the real functions with a synthetic catalogue and a local transfer.
  # The installed namespace and the real Wiley records remain untouched.
  fixture <- new.env(parent = asNamespace("asaData"))
  functions <- c("asa_datasets", "download_asa", "read_asa", "read_asa_all",
                 ls(asNamespace("asaData"), pattern = "^\\.asa_", all.names = TRUE))
  for (name in functions) {
    fn <- get(name, asNamespace("asaData"))
    environment(fn) <- fixture
    fixture[[name]] <- fn
  }
  fixture$manifest <- manifest[manifest$dataset == "bpd", ]
  fixture$manifest$rows <- 2L
  fixture$manifest$md5 <- unname(tools::md5sum(file))
  fixture$asa_datasets <- eval(quote(function() manifest), fixture)
  expected <- data.frame(id = 1:2, surfact = 0:1, ondays = c(12L, 20L), censor = 1:0)
  stopifnot(identical(fixture$read_asa("bpd", file), expected))
  expect_error(read_asa("bpd", file), "checksum")
  expect_error(read_asa("bpd", scratch), "checksum")
  expect_error(download_asa("bpd", cache_dir = file), "Cannot create cache")

  # Correct checksums alone are insufficient: values and layout are checked too.
  check_bad <- function(lines, pattern) {
    writeLines(lines, file, useBytes = TRUE)
    fixture$manifest$md5 <- unname(tools::md5sum(file))
    expect_error(fixture$read_asa("bpd", file), pattern)
  }
  check_bad(c("1 0 12.5 1", "2 1 20 0"), "Invalid values")
  check_bad(c("1 0 bad 1", "2 1 20 0"), "Invalid values")
  check_bad(c("1 0 Inf 1", "2 1 20 0"), "Invalid values")
  check_bad(c("1 0 2147483648 1", "2 1 20 0"), "Invalid values")
  check_bad(c("1 0 . 1", "2 1 20 0"), "missing values")
  check_bad("1 0 12 1", "dimensions")
  writeLines(c("1 0 12 1", "2 1 20 0"), file, useBytes = TRUE)
  fixture$manifest$md5 <- unname(tools::md5sum(file))

  # English month parsing is independent of the session's current locale.
  date_file <- file.path(scratch, "hmohiv.dat")
  writeLines(c("1 01Jan90 01Feb90 1 30 0 1", "2 01mar90 01apr90 1 35 1 0"),
             date_file, useBytes = TRUE)
  fixture$manifest <- manifest[manifest$dataset == "hmohiv", ]
  fixture$manifest$rows <- 2L
  fixture$manifest$md5 <- unname(tools::md5sum(date_file))
  locale <- Sys.getlocale("LC_TIME")
  dates <- fixture$read_asa("hmohiv", date_file)
  stopifnot(identical(dates$entdate, as.Date(c("1990-01-01", "1990-03-01"))),
            identical(Sys.getlocale("LC_TIME"), locale))
  writeLines(c("1 31Feb90 01Mar90 1 30 0 1", "2 01mar90 01apr90 1 35 1 0"),
             date_file, useBytes = TRUE)
  fixture$manifest$md5 <- unname(tools::md5sum(date_file))
  expect_error(fixture$read_asa("hmohiv", date_file), "Invalid values")
  stopifnot(identical(Sys.getlocale("LC_TIME"), locale))

  # Preserve declared missing values and doubles using an artificial FRTCS table.
  missing_file <- file.path(scratch, "FRTCS.dat")
  columns <- schema[schema$dataset == "frtcs", ]
  values <- matrix("1", nrow = max(columns$missing) + 1L, ncol = nrow(columns))
  for (j in seq_len(nrow(columns))) {
    if (columns$storage[j] == "double") values[, j] <- "1.25"
    if (columns$storage[j] == "Date") {
      values[, j] <- format(as.Date("2000-01-01"), columns$date_format[j])
    }
    if (columns$missing[j] > 0L) values[seq_len(columns$missing[j]), j] <- "."
  }
  write.table(values, missing_file, row.names = FALSE, col.names = FALSE, quote = FALSE)
  fixture$manifest <- manifest[manifest$dataset == "frtcs", ]
  fixture$manifest$rows <- nrow(values)
  fixture$manifest$md5 <- unname(tools::md5sum(missing_file))
  missing <- fixture$read_asa("frtcs", missing_file)
  stopifnot(identical(as.integer(colSums(is.na(missing))), columns$missing),
            all(vapply(missing[columns$storage == "double"], typeof, "") == "double"))

  # ZIP creation is only needed for these synthetic download tests.
  if (!nzchar(Sys.which(Sys.getenv("R_ZIPCMD", "zip")))) {
    message("Archive tests skipped: the standard zip utility is unavailable.")
    return(invisible(NULL))
  }
  archive <- file.path(scratch, "source.zip")
  utils::zip(archive, files = file, flags = "-j -q")
  stopifnot(file.exists(archive))
  fixture$manifest <- manifest[manifest$dataset == "bpd", ]
  fixture$manifest$rows <- 2L
  fixture$manifest$md5 <- unname(tools::md5sum(file))
  fixture$source_archive <- archive
  fixture$calls <- 0L
  fixture$fail <- FALSE
  fixture$.asa_fetch <- eval(quote(function(url, destination, quiet) {
    calls <<- calls + 1L
    if (fail) {
      writeLines("incomplete transfer", destination)
      stop("Simulated network failure.")
    }
    stopifnot(file.copy(source_archive, destination, overwrite = TRUE))
  }), fixture)
  cache <- file.path(scratch, "cache")
  actual <- fixture$download_asa("bpd", source = "wiley", cache_dir = cache)
  stopifnot(identical(actual, expected), fixture$calls == 1L,
            identical(list.files(cache), "edition2.zip"))
  fixture$fail <- TRUE
  stopifnot(identical(fixture$download_asa("bpd", source = "wiley", cache_dir = cache), expected),
            fixture$calls == 1L)
  old_hash <- tools::md5sum(file.path(cache, "edition2.zip"))
  expect_error(fixture$download_asa("bpd", source = "wiley", cache_dir = cache, refresh = TRUE), "Simulated network failure")
  stopifnot(identical(old_hash, tools::md5sum(file.path(cache, "edition2.zip"))),
            identical(list.files(cache), "edition2.zip"))
  fixture$fail <- FALSE
  stopifnot(identical(fixture$download_asa("bpd", source = "wiley", cache_dir = cache, refresh = TRUE), expected),
            fixture$calls == 3L)
  # A downloaded HTML/error page must not replace a valid cached archive.
  fixture$source_archive <- file
  expect_error(fixture$download_asa("bpd", source = "wiley", cache_dir = cache, refresh = TRUE), "expected file")
  stopifnot(identical(old_hash, tools::md5sum(file.path(cache, "edition2.zip"))),
            identical(list.files(cache), "edition2.zip"))
  fixture$source_archive <- archive
  writeLines("broken archive", file.path(cache, "edition2.zip"))
  expect_error(fixture$download_asa("bpd", source = "wiley", cache_dir = cache), "refresh = TRUE")
  stopifnot(identical(fixture$download_asa("bpd", source = "wiley", cache_dir = cache, refresh = TRUE), expected))
  # A valid ZIP containing modified records must also be rejected.
  changed <- file.path(scratch, "changed.zip")
  writeLines(c("1 0 99 1", "2 1 20 0"), file, useBytes = TRUE)
  utils::zip(changed, files = file, flags = "-j -q")
  fixture$source_archive <- changed
  expect_error(fixture$download_asa("bpd", source = "wiley", cache_dir = cache, refresh = TRUE), "checksum")
  stopifnot(identical(old_hash, tools::md5sum(file.path(cache, "edition2.zip"))),
            identical(list.files(cache), "edition2.zip"))
  # Local paths and batch imports never use the network.
  fixture$.asa_fetch <- function(...) stop("Unexpected network request.")
  stopifnot(identical(fixture$read_asa("bpd", archive), expected),
            identical(fixture$read_asa("bpd", cache), expected),
            identical(fixture$read_asa_all(archive), list(bpd = expected)),
            identical(fixture$read_asa_all(cache), list(bpd = expected)),
            identical(fixture$read_asa_all(c(archive, archive)), list(bpd = expected)))
  expect_error(fixture$read_asa_all(changed), "checksum")
  expect_error(fixture$read_asa_all(file), "ZIP archives or folders")
  expect_error(fixture$read_asa_all(character()), "'file'")
  expect_error(fixture$read_asa_all(NA_character_), "'file'")
  expect_error(fixture$read_asa_all("absent.zip"), "does not exist")
  empty <- file.path(scratch, "empty")
  dir.create(empty)
  expect_error(fixture$read_asa_all(empty), "No supported data")
  expect_error(fixture$read_asa("bpd", empty), "No supported local file")

  # Simulate the two sources, including a failed Wiley download and UCLA reuse.
  # The stand-in SPSS reader isolates transfer handling from format conversion.
  sav <- file.path(scratch, "bpd.sav")
  writeLines("synthetic SPSS transfer", sav)
  ucla_archive <- file.path(scratch, "ucla.zip")
  utils::zip(ucla_archive, files = sav, flags = "-j -q")
  fixture$manifest$ucla_md5 <- unname(tools::md5sum(sav))
  fixture$ucla_archive <- ucla_archive
  fixture$source_archive <- archive
  fixture$expected <- expected
  fixture$fail_wiley <- TRUE
  fixture$fail_ucla <- FALSE
  fixture$sites <- character()
  fixture$.asa_read_spss <- eval(quote(function(file, metadata) {
    .asa_checksum(file, metadata, metadata$ucla_md5)
    expected
  }), fixture)
  fixture$.asa_fetch <- eval(quote(function(url, destination, quiet) {
    site <- if (grepl("ucla.edu", url, fixed = TRUE)) "ucla" else "wiley"
    sites <<- c(sites, site)
    if ((site == "wiley" && fail_wiley) || (site == "ucla" && fail_ucla)) {
      stop(paste("Simulated failure from", site))
    }
    from <- if (site == "wiley") source_archive else ucla_archive
    stopifnot(file.copy(from, destination, overwrite = TRUE))
  }), fixture)
  fallback <- file.path(scratch, "fallback")
  stopifnot(identical(suppressMessages(fixture$download_asa("bpd", fallback)), expected),
            identical(fixture$sites, c("wiley", "ucla")),
            identical(list.files(fallback), "ucla-asa2-spss.zip"))
  fixture$sites <- character()
  fixture$fail_ucla <- TRUE
  stopifnot(identical(suppressMessages(fixture$download_asa("bpd", fallback)), expected),
            !length(fixture$sites),
            identical(fixture$read_asa("bpd", fallback), expected),
            identical(fixture$read_asa_all(fallback), list(bpd = expected)))
  ucla_hash <- tools::md5sum(file.path(fallback, "ucla-asa2-spss.zip"))
  expect_error(fixture$download_asa("bpd", fallback, refresh = TRUE), "Simulated failure from wiley")
  expect_error(fixture$download_asa("bpd", fallback, refresh = TRUE), "Simulated failure from ucla")
  stopifnot(identical(ucla_hash, tools::md5sum(file.path(fallback, "ucla-asa2-spss.zip"))),
            identical(list.files(fallback), "ucla-asa2-spss.zip"))
  fixture$sites <- character()
  fixture$fail_ucla <- FALSE
  stopifnot(identical(fixture$download_asa("bpd", fallback, refresh = TRUE, source = "ucla"), expected),
            identical(fixture$sites, "ucla"))
  fixture$fail_wiley <- FALSE
  fixture$sites <- character()
  stopifnot(identical(fixture$download_asa("bpd", fallback, refresh = TRUE), expected),
            identical(fixture$sites, "wiley"))
  # A corrupt Wiley cache can fall back, but must not be overwritten implicitly.
  writeLines("invalid archive", file.path(fallback, "edition2.zip"))
  fixture$sites <- character()
  stopifnot(identical(suppressMessages(fixture$download_asa("bpd", fallback)), expected),
            !length(fixture$sites),
            identical(readLines(file.path(fallback, "edition2.zip")), "invalid archive"))
  fixture$manifest <- manifest[manifest$dataset == "actg320", ]
  expect_error(fixture$download_asa("actg320", fallback, source = "ucla"), "No verified UCLA copy")
  fixture$fail_wiley <- TRUE
  expect_error(fixture$download_asa("actg320", fallback, refresh = TRUE), "No verified UCLA copy")
  cat("Synthetic import, download, fallback, batch, cache, and failure checks passed.\n")
})
