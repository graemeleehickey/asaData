#' List the Available Applied Survival Analysis Datasets
#'
#' List the datasets supported by \code{download_asa()} without accessing the internet.
#'
#' @return A data frame with dataset names, the source edition, dimensions, source filenames, MD5 checksums, and Wiley archive URLs. The shared \code{recur} and \code{uis} datasets use the second-edition archive.
#' @seealso \code{\link{download_asa}}, \code{\link{read_asa}}
#' @examples
#' asa_datasets()
#' @export
asa_datasets <- function() {
  utils::read.csv(system.file("metadata", "manifest.csv", package = "asaData",
                             mustWork = TRUE), stringsAsFactors = FALSE)
}

#' Download an Applied Survival Analysis Dataset
#'
#' Download a Wiley companion archive and return the selected dataset as an R data frame.
#'
#' @param name A single dataset name from \code{asa_datasets()}, for example \code{"whas500"}.
#' @param cache_dir Directory for downloaded ZIP archives. The default is a temporary directory for the current R session. Supply a directory of your choice to reuse downloads between sessions.
#' @param refresh Download the archive again, even if a cached copy exists. The previous copy is retained if downloading or validating the replacement fails.
#' @param quiet Suppress download progress messages.
#' @details
#' Wiley supplies one ZIP archive per edition. The first request for an edition downloads that archive, including its accompanying codebooks; later requests reuse it. Only the requested data file is extracted, to temporary storage. Nothing is downloaded when the package is installed or loaded.
#'
#' Every returned dataset is checked against the recorded source checksum, dimensions, missing-value counts, and variable types. A changed or damaged file is rejected. Use \code{refresh = TRUE} to replace a damaged cache; if Wiley has changed the source, the package metadata will need updating.
#'
#' Variable names are lower case, category codes remain numeric, calendar dates become \code{Date} objects, and source missing-value dots become \code{NA}. Row order and numeric values are preserved. The shared \code{recur} and \code{uis} datasets use the second-edition files; the two WHAS nested case-control samples have separate names.
#'
#' The package contains no dataset records or original codebooks. The GPL-3 licence covers the package code and original documentation, not downloaded materials. Consult the source terms before downloading or reusing the data. A local source file can instead be imported with \code{read_asa()}.
#' @return A data frame. No objects are assigned to the user's workspace. Download and validation failures produce an informative error.
#' @source \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#' @seealso \code{\link{asa_datasets}}, \code{\link{read_asa}}, \code{\link{whas500}}
#' @examples
#' \dontrun{
#' whas500 <- download_asa("whas500")
#' head(whas500)
#' # The second-edition archive is reused for this request.
#' gbcs <- download_asa("gbcs")
#' }
#' @export
download_asa <- function(name, cache_dir = file.path(tempdir(), "asaData"),
                         refresh = FALSE, quiet = TRUE) {
  metadata <- .asa_metadata(name)
  .asa_string(cache_dir, "cache_dir")
  if (!is.logical(refresh) || length(refresh) != 1L || is.na(refresh)) {
    stop("'refresh' must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.logical(quiet) || length(quiet) != 1L || is.na(quiet)) {
    stop("'quiet' must be TRUE or FALSE.", call. = FALSE)
  }
  cache_dir <- path.expand(cache_dir)
  if (!dir.exists(cache_dir) &&
      !dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)) {
    stop("Cannot create cache directory: ", cache_dir, call. = FALSE)
  }
  archive <- file.path(cache_dir, paste0("edition", metadata$edition, ".zip"))
  if (file.exists(archive) && !refresh) {
    return(.asa_read_archive(archive, metadata))
  }

  candidate <- tempfile("asa-download-", tmpdir = cache_dir, fileext = ".zip")
  on.exit(unlink(candidate), add = TRUE)
  .asa_fetch(metadata$url, candidate, quiet)
  result <- .asa_read_archive(candidate, metadata)
  if (!file.copy(candidate, archive, overwrite = TRUE)) {
    stop("Cannot save the validated archive to: ", archive, call. = FALSE)
  }
  result
}

#' Read a Locally Downloaded Applied Survival Analysis Dataset
#'
#' Import an original Wiley \file{.dat} file without accessing the internet or writing a cache.
#'
#' @param name A single dataset name from \code{asa_datasets()}.
#' @param file Path to the original, unmodified \file{.dat} file, extracted from the appropriate Wiley archive.
#' @details The same checksum, layout, and type checks are used as for \code{download_asa()}. Files from another edition, edited files, and files with changed line endings are rejected if their checksums differ. For \code{recur} and \code{uis}, use the second-edition file.
#' @return A data frame with the variables described in the corresponding dataset help page.
#' @seealso \code{\link{download_asa}}, \code{\link{asa_datasets}}
#' @examples
#' \dontrun{
#' whas500 <- read_asa("whas500", "path/to/whas500.dat")
#' }
#' @export
read_asa <- function(name, file) {
  metadata <- .asa_metadata(name)
  .asa_string(file, "file")
  file <- path.expand(file)
  if (!file.exists(file) || dir.exists(file)) {
    stop("Source file does not exist: ", file, call. = FALSE)
  }
  .asa_read_file(file, metadata)
}

.asa_string <- function(x, argument) {
  if (!is.character(x) || length(x) != 1L || is.na(x) || !nzchar(x)) {
    stop("'", argument, "' must be a single non-empty character string.", call. = FALSE)
  }
}

.asa_metadata <- function(name) {
  .asa_string(name, "name")
  manifest <- asa_datasets()
  if (!name %in% manifest$dataset) {
    stop("Unknown dataset '", name, "'. Use asa_datasets() to list valid names.",
         call. = FALSE)
  }
  manifest[manifest$dataset == name, , drop = FALSE]
}

.asa_fetch <- function(url, destination, quiet) {
  tryCatch({
    status <- utils::download.file(url, destination, method = "libcurl",
                                   mode = "wb", quiet = quiet)
    if (!identical(status, 0L)) stop("The download did not complete.")
  }, warning = function(w) {
    stop("Could not download the Wiley archive: ", conditionMessage(w),
         "\nSource: ", url,
         "\nCheck your connection or use read_asa() with a local source file.", call. = FALSE)
  }, error = function(e) {
    stop("Could not download the Wiley archive: ", conditionMessage(e),
         "\nSource: ", url,
         "\nCheck your connection or use read_asa() with a local source file.", call. = FALSE)
  })
}

.asa_read_archive <- function(archive, metadata) {
  contents <- tryCatch(suppressWarnings(utils::unzip(archive, list = TRUE)),
                       error = function(e) NULL)
  if (is.null(contents) || sum(contents$Name == metadata$file) != 1L) {
    stop("Archive does not contain the expected file '", metadata$file,
         "'. Use refresh = TRUE to download it again: ", archive, call. = FALSE)
  }
  scratch <- tempfile("asa-extract-")
  dir.create(scratch)
  on.exit(unlink(scratch, recursive = TRUE), add = TRUE)
  tryCatch(utils::unzip(archive, files = metadata$file, exdir = scratch),
           warning = function(w) stop("Cannot extract the dataset: ", conditionMessage(w), call. = FALSE),
           error = function(e) stop("Cannot extract the dataset: ", conditionMessage(e), call. = FALSE))
  .asa_read_file(file.path(scratch, metadata$file), metadata)
}

.asa_read_file <- function(file, metadata) {
  actual <- unname(tools::md5sum(file))
  if (is.na(actual) || !identical(actual, metadata$md5)) {
    stop("Source checksum differs from the recorded version for '", metadata$dataset,
         "'. The file may be damaged or changed. For a cached download, try refresh = TRUE.",
         call. = FALSE)
  }
  schema <- utils::read.csv(system.file("metadata", "schema.csv", package = "asaData",
                                       mustWork = TRUE), stringsAsFactors = FALSE)
  schema <- schema[schema$dataset == metadata$dataset, , drop = FALSE]
  raw <- utils::read.table(file, header = FALSE, colClasses = "character",
                           na.strings = ".", quote = "", comment.char = "",
                           col.names = schema$variable, row.names = NULL,
                           check.names = FALSE)
  if (nrow(raw) != metadata$rows || ncol(raw) != metadata$columns ||
      !identical(as.integer(colSums(is.na(raw))), as.integer(schema$missing))) {
    stop("Unexpected dimensions or missing values for '", metadata$dataset, "'.", call. = FALSE)
  }
  old_locale <- Sys.getlocale("LC_TIME")
  on.exit(Sys.setlocale("LC_TIME", old_locale), add = TRUE)
  if (!nzchar(Sys.setlocale("LC_TIME", "C"))) {
    stop("Cannot select English month names for date conversion.", call. = FALSE)
  }
  result <- raw
  for (j in seq_len(nrow(schema))) {
    if (schema$storage[j] == "Date") {
      parsed <- as.Date(raw[[j]], format = schema$date_format[j])
      valid <- identical(is.na(parsed), is.na(raw[[j]])) &&
        all(tolower(format(parsed, schema$date_format[j])) == tolower(raw[[j]]), na.rm = TRUE)
    } else {
      parsed <- suppressWarnings(as.numeric(raw[[j]]))
      valid <- identical(is.na(parsed), is.na(raw[[j]])) &&
        all(is.finite(parsed[!is.na(parsed)]))
      if (schema$storage[j] == "integer") {
        valid <- valid && all(parsed == trunc(parsed), na.rm = TRUE)
        parsed <- suppressWarnings(as.integer(parsed))
        valid <- valid && identical(is.na(parsed), is.na(raw[[j]]))
      }
    }
    if (!valid) {
      stop("Invalid values in '", metadata$dataset, "$", schema$variable[j], "'.", call. = FALSE)
    }
    result[[j]] <- parsed
  }
  result
}
