#' List the Available Applied Survival Analysis Datasets
#'
#' List the datasets supported by \code{download_asa()} without accessing the internet.
#'
#' @return A data frame with dataset names, the source edition, dimensions, source filenames, MD5 checksums, and archive URLs. The \code{ucla_file}, \code{ucla_md5}, and \code{ucla_url} columns are empty where no verified UCLA alternative is available. The shared \code{recur} and \code{uis} datasets download from the second-edition Wiley archive; \code{first_edition_md5} identifies their equivalent first-edition files for local imports.
#' @seealso \code{\link{download_asa}}, \code{\link{download_asa_all}}, \code{\link{read_asa}}, \code{\link{read_asa_all}}
#' @examples
#' asa_datasets()
#' @export
asa_datasets <- function() {
  utils::read.csv(system.file("metadata", "manifest.csv", package = "asaData",
                             mustWork = TRUE), stringsAsFactors = FALSE)
}

#' Download an Applied Survival Analysis Dataset
#'
#' Download a companion archive from Wiley or UCLA and return the selected dataset as an R data frame.
#'
#' @param name A single dataset name from \code{asa_datasets()}, for example \code{"whas500"}.
#' @param cache_dir Directory for downloaded ZIP archives. The default is a temporary directory for the current R session. Supply a directory of your choice to reuse downloads between sessions.
#' @param refresh Download the archive again, even if a cached copy exists. The previous copy is retained if downloading or validating the replacement fails.
#' @param quiet Suppress download progress messages.
#' @param source \code{"auto"}, \code{"wiley"}, or \code{"ucla"}. The default is \code{"auto"}: reuse cached archives, preferring Wiley, then try downloading from Wiley followed by UCLA. UCLA is available for six verified datasets only. A message identifies automatic use of UCLA, even when \code{quiet = TRUE}.
#' @details
#' Wiley supplies one ZIP archive per edition. UCLA supplies an SPSS archive; verified alternatives are available for \code{bpd}, \code{gbcs}, \code{grace1000}, \code{uis}, \code{whas100}, and \code{whas500}. Other UCLA copies are not substituted because they are absent, incomplete, or have not been verified against Wiley. Only the requested data file is extracted, to temporary storage. Nothing is downloaded when the package is installed or loaded.
#'
#' Every source file is checked against its recorded checksum, and every returned dataset is checked for dimensions, missing-value counts, and variable types. Changed or damaged files are rejected. With automatic selection, a failed download or rejected file triggers the next available source; errors from both sources are reported if neither succeeds. Use \code{refresh = TRUE} to bypass cached copies. Each source has a separate cache, and a failed replacement leaves the previous copy intact.
#'
#' Variable names are lower case, category codes remain numeric, calendar dates become \code{Date} objects, and missing values become \code{NA}. UCLA imports use \pkg{foreign}. Names and dates are converted to the Wiley definitions, WHAS100 rows are restored to ID order, UIS Beck scores are rounded to three decimal places, and WHAS BMI values are rounded to five decimal places. These conversions reproduce all Wiley values and row orders for the six supported copies. The shared \code{recur} and \code{uis} datasets use the second-edition definitions; the two WHAS nested case-control samples have separate names.
#'
#' The package contains no dataset records or original codebooks. The GPL-3 licence covers the package code and original documentation, not downloaded materials. Consult the source terms before downloading or reusing the data. For offline use, pass a saved file, ZIP archive, or folder to \code{read_asa()}.
#' @return A data frame. No objects are assigned to the user's workspace. Download and validation failures produce an informative error.
#' @source \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}.
#' @seealso \code{\link{download_asa_all}}, \code{\link{asa_datasets}}, \code{\link{read_asa}}, \code{\link{whas500}}
#' @examples
#' \dontrun{
#' whas500 <- download_asa("whas500")
#' head(whas500)
#' # The second-edition archive is reused for this request.
#' gbcs <- download_asa("gbcs")
#' # Select a source explicitly, or keep copies between sessions.
#' whas500 <- download_asa("whas500", source = "ucla")
#' whas500 <- download_asa("whas500", cache_dir = "~/asaData-cache")
#' }
#' @export
download_asa <- function(name, cache_dir = file.path(tempdir(), "asaData"),
                         refresh = FALSE, quiet = TRUE,
                         source = c("auto", "wiley", "ucla")) {
  metadata <- .asa_metadata(name)
  source <- match.arg(source)
  .asa_download_arguments(cache_dir, refresh, quiet)
  .asa_download_dataset(metadata, cache_dir, refresh, quiet, source)
}

#' Download All Applied Survival Analysis Datasets
#'
#' Download and import all 16 datasets in one call, using the checks and conversions described in \code{download_asa()}.
#'
#' @inheritParams download_asa
#' @param source \code{"auto"} (default) or \code{"wiley"}. Automatic selection follows \code{download_asa()}, including verified UCLA alternatives where available. UCLA alone cannot supply all 16 datasets.
#' @details Archives are shared between datasets. With no existing cache, a successful Wiley download requires only two archives. Each archive is downloaded at most once per call, including when \code{refresh = TRUE}. Valid cached archives are reused unless a refresh is requested.
#'
#' If any dataset cannot be imported, the function stops with an error naming that dataset and returns no partial list. Successfully validated downloads remain in the cache for a later attempt. A failed refresh does not silently reuse an older copy. Use \code{read_asa_all()} to import available datasets from saved archives without internet access.
#' @return A named list of all 16 data frames, in the order used by \code{asa_datasets()}. No objects are assigned to the user's workspace. Use \code{list2env()} explicitly if separate objects are wanted.
#' @seealso \code{\link{download_asa}}, \code{\link{read_asa_all}}, \code{\link{asa_datasets}}
#' @examples
#' \dontrun{
#' datasets <- download_asa_all()
#' names(datasets)
#' head(datasets$whas500)
#' # Keep the archives between R sessions.
#' datasets <- download_asa_all(cache_dir = "~/asaData-cache")
#' # Optional: create separate objects in your workspace.
#' list2env(datasets, envir = .GlobalEnv)
#' }
#' @export
download_asa_all <- function(cache_dir = file.path(tempdir(), "asaData"),
                             refresh = FALSE, quiet = TRUE,
                             source = c("auto", "wiley")) {
  source <- match.arg(source)
  .asa_download_arguments(cache_dir, refresh, quiet)
  manifest <- asa_datasets()
  result <- vector("list", nrow(manifest))
  names(result) <- manifest$dataset
  transfers <- new.env(parent = emptyenv())
  for (i in seq_len(nrow(manifest))) {
    result[[i]] <- tryCatch(
      .asa_download_dataset(manifest[i, , drop = FALSE], cache_dir, refresh,
                             quiet, source, transfers),
      error = function(e) {
        stop("Could not load all datasets: failed at '", manifest$dataset[i],
             "'. No partial list was returned.\n", conditionMessage(e), call. = FALSE)
      })
  }
  result
}

.asa_download_arguments <- function(cache_dir, refresh, quiet) {
  .asa_string(cache_dir, "cache_dir")
  if (!is.logical(refresh) || length(refresh) != 1L || is.na(refresh)) {
    stop("'refresh' must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.logical(quiet) || length(quiet) != 1L || is.na(quiet)) {
    stop("'quiet' must be TRUE or FALSE.", call. = FALSE)
  }
}

.asa_download_dataset <- function(metadata, cache_dir, refresh, quiet, source,
                                    transfers = NULL) {
  name <- metadata$dataset
  sources <- if (source == "auto") c("wiley", "ucla") else source
  if (!nzchar(metadata$ucla_file)) {
    if (source == "ucla") {
      stop("No verified UCLA copy is available for '", name,
           "'. Use Wiley or read_asa() with a local Wiley copy.", call. = FALSE)
    }
    sources <- "wiley"
  }
  cache_dir <- path.expand(cache_dir)
  if (!dir.exists(cache_dir) &&
      !dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)) {
    stop("Cannot create cache directory: ", cache_dir, call. = FALSE)
  }
  archives <- c(wiley = file.path(cache_dir, paste0("edition", metadata$edition, ".zip")),
                ucla = file.path(cache_dir, "ucla-asa2-spss.zip"))
  if (source == "auto" && !refresh) {
    cached <- file.exists(archives[sources])
    sources <- c(sources[cached], sources[!cached])
  }
  failures <- character()
  for (site in sources) {
    result <- tryCatch(.asa_download_source(metadata, archives[[site]], site,
                                            refresh, quiet, transfers), error = identity)
    if (!inherits(result, "error")) {
      if (source == "auto" && site == "ucla") {
        message("Using the verified UCLA copy of '", name, "'.")
      }
      return(result)
    }
    failures <- c(failures, paste0(toupper(site), ": ", conditionMessage(result)))
  }
  unavailable <- if (source == "auto" && !nzchar(metadata$ucla_file)) {
    paste0("\nNo verified UCLA copy is available for '", name, "'.")
  } else ""
  stop(paste(failures, collapse = "\n"), unavailable,
       "\nUse read_asa() with a local data file, ZIP archive, or folder.", call. = FALSE)
}

.asa_download_source <- function(metadata, archive, source, refresh, quiet,
                                  transfers = NULL) {
  if (!is.null(transfers) && exists(archive, envir = transfers, inherits = FALSE)) {
    previous <- get(archive, envir = transfers, inherits = FALSE)
    if (inherits(previous, "error")) stop(previous)
    return(.asa_read_archive(archive, metadata, source))
  }
  if (file.exists(archive) && !refresh) {
    return(.asa_read_archive(archive, metadata, source))
  }
  candidate <- tempfile("asa-download-", tmpdir = dirname(archive), fileext = ".zip")
  on.exit(unlink(candidate), add = TRUE)
  url <- if (source == "wiley") metadata$url else metadata$ucla_url
  result <- tryCatch({
    .asa_fetch(url, candidate, quiet)
    value <- .asa_read_archive(candidate, metadata, source)
    if (!file.copy(candidate, archive, overwrite = TRUE)) {
      stop("Cannot save the validated archive to: ", archive, call. = FALSE)
    }
    value
  }, error = identity)
  if (!is.null(transfers)) {
    assign(archive, if (inherits(result, "error")) result else TRUE, envir = transfers)
  }
  if (inherits(result, "error")) stop(result)
  result
}

#' Read a Locally Downloaded Applied Survival Analysis Dataset
#'
#' Import a saved data file, ZIP archive, or folder without accessing the internet or writing a cache.
#'
#' @param name A single dataset name from \code{asa_datasets()}.
#' @param file Path to an original Wiley \file{.dat} file, a supported UCLA \file{.sav} file, either site's ZIP archive, or a folder containing these files.
#' @details The same source checks and conversions are used as for \code{download_asa()}. Edited files and files with changed line endings are rejected if their checksums differ. Either edition's original \code{recur} and \code{uis} files is accepted; values agree, and the returned names follow the second edition. Other files must match the requested edition. UCLA support is limited to the six datasets listed in \code{download_asa()}.
#'
#' In a folder, the function looks for the expected Wiley filename, then the supported UCLA filename, then an archive named \file{edition1.zip} or \file{edition2.zip} as appropriate, Wiley's original archive name, \file{ucla-asa2-spss.zip}, or \file{asa2_spss.zip}. The first matching file is checked; an invalid copy is reported rather than silently skipped. Subfolders are not searched. Keep different editions in separate folders because some filenames are shared. A ZIP archive supplied directly may have any filename ending in \file{.zip}.
#' @return A data frame with the variables described in the corresponding dataset help page.
#' @seealso \code{\link{download_asa}}, \code{\link{asa_datasets}}, \code{\link{read_asa_all}}
#' @examples
#' \dontrun{
#' whas500 <- read_asa("whas500", "path/to/whas500.dat")
#' whas500 <- read_asa("whas500", "path/to/Second-Edition Data.zip")
#' whas500 <- read_asa("whas500", "~/asaData-cache")
#' whas500 <- read_asa("whas500", "path/to/asa2_spss.zip")
#' }
#' @export
read_asa <- function(name, file) {
  metadata <- .asa_metadata(name)
  .asa_string(file, "file")
  file <- path.expand(file)
  if (dir.exists(file)) {
    candidates <- c(metadata$file, metadata$ucla_file,
                    paste0("edition", metadata$edition, ".zip"),
                    utils::URLdecode(basename(metadata$url)))
    if (nzchar(metadata$ucla_file)) {
      candidates <- c(candidates, "ucla-asa2-spss.zip", "asa2_spss.zip")
    }
    paths <- file.path(file, candidates[nzchar(candidates)])
    paths <- paths[file.exists(paths) & !dir.exists(paths)]
    if (!length(paths)) {
      stop("No supported local file for '", name, "' in: ", file,
           ". Supply a data file or ZIP archive directly.", call. = FALSE)
    }
    file <- paths[1L]
  }
  if (!file.exists(file)) {
    stop("Source file does not exist: ", file, call. = FALSE)
  }
  extension <- tolower(tools::file_ext(file))
  if (extension == "zip") return(.asa_read_archive(file, metadata))
  if (extension == "sav") return(.asa_read_spss(file, metadata))
  .asa_read_file(file, metadata)
}

#' Read All Available Datasets from Local Archives or Folders
#'
#' Import supported datasets together without accessing the internet or assigning objects to the user's workspace.
#'
#' @param file One or more paths to saved ZIP archives or folders containing original data files or ZIP archives. Subfolders are not searched.
#' @details The first-edition Wiley archive supplies five datasets; the second supplies thirteen. Supply both archives, or a folder containing both, to obtain all 16 datasets. Shared \code{recur} and \code{uis} files are represented once. The two WHAS nested case-control samples are distinguished by their checksums. A UCLA SPSS archive supplies the six verified alternatives described in \code{download_asa()}.
#'
#' Original filenames inside archives or folders are used to identify candidate data files; archive filenames may be changed. Codebooks and unsupported files are ignored. Every recognised data file must pass its source checksum and data checks, including duplicate copies. A damaged recognised file stops the import with an error. When Wiley and UCLA copies are both supplied, Wiley is used. Files are extracted only to temporary storage and removed after import.
#' @return A named list of data frames, in the order used by \code{asa_datasets()}. Only datasets available in the supplied paths are included. Use \code{names()} to see which were imported. An error is raised if no supported data files are found. Optionally use \code{list2env()} to create separate objects explicitly.
#' @seealso \code{\link{read_asa}}, \code{\link{download_asa_all}}, \code{\link{download_asa}}, \code{\link{asa_datasets}}
#' @examples
#' \dontrun{
#' # Both Wiley ZIP archives saved in one folder: returns all 16 datasets.
#' datasets <- read_asa_all("~/Downloads/asa-data")
#' names(datasets)
#' # Alternatively, supply the archive paths directly.
#' datasets <- read_asa_all(c("path/to/First-Edition Data.zip",
#'                            "path/to/Second-Edition Data.zip"))
#' # Optional: create a separate R object for each dataset.
#' list2env(datasets, envir = .GlobalEnv)
#' }
#' @export
read_asa_all <- function(file) {
  if (!is.character(file) || !length(file) || anyNA(file) || any(!nzchar(file))) {
    stop("'file' must contain one or more paths to ZIP archives or folders.", call. = FALSE)
  }
  paths <- path.expand(file)
  if (any(!file.exists(paths))) {
    stop("Source path does not exist: ", paths[!file.exists(paths)][1L], call. = FALSE)
  }
  if (any(!dir.exists(paths) & tolower(tools::file_ext(paths)) != "zip")) {
    stop("Supply ZIP archives or folders; use read_asa() for an individual data file.", call. = FALSE)
  }
  paths <- unique(unlist(lapply(paths, function(path) {
    if (dir.exists(path)) list.files(path, full.names = TRUE) else path
  }), use.names = FALSE))
  paths <- paths[!dir.exists(paths)]
  manifest <- asa_datasets()
  known <- unique(c(manifest$file, manifest$ucla_file[nzchar(manifest$ucla_file)]))
  scratch <- tempfile("asa-batch-")
  dir.create(scratch)
  on.exit(unlink(scratch, recursive = TRUE), add = TRUE)
  inputs <- paths[basename(paths) %in% known]
  archives <- paths[tolower(tools::file_ext(paths)) == "zip"]
  for (i in seq_along(archives)) {
    contents <- tryCatch(suppressWarnings(utils::unzip(archives[i], list = TRUE)),
                         error = function(e) NULL)
    if (is.null(contents)) stop("Cannot read ZIP archive: ", archives[i], call. = FALSE)
    members <- contents$Name[contents$Name %in% known]
    if (anyDuplicated(members)) {
      stop("Duplicate data filenames in ZIP archive: ", archives[i], call. = FALSE)
    }
    if (!length(members)) next
    destination <- file.path(scratch, as.character(i))
    dir.create(destination)
    utils::unzip(archives[i], files = members, exdir = destination)
    inputs <- c(inputs, file.path(destination, members))
  }
  if (!length(inputs)) stop("No supported data files were found in the supplied paths.", call. = FALSE)
  # Prefer Wiley when both formats are present; still check every recognised copy.
  inputs <- inputs[order(tolower(tools::file_ext(inputs)) == "sav")]
  result <- list()
  for (path in inputs) {
    spss <- tolower(tools::file_ext(path)) == "sav"
    filename <- if (spss) manifest$ucla_file else manifest$file
    checksum <- unname(tools::md5sum(path))
    matches <- if (spss) manifest$ucla_md5 == checksum else {
      manifest$md5 == checksum | manifest$first_edition_md5 == checksum
    }
    metadata <- manifest[filename == basename(path) & matches, , drop = FALSE]
    if (nrow(metadata) != 1L) {
      stop("Source checksum differs from the recorded versions for '", basename(path),
           "'. No datasets were returned.", call. = FALSE)
    }
    value <- if (spss) .asa_read_spss(path, metadata) else .asa_read_file(path, metadata)
    if (is.null(result[[metadata$dataset]])) result[[metadata$dataset]] <- value
  }
  result[manifest$dataset[manifest$dataset %in% names(result)]]
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
  status <- tryCatch(utils::download.file(url, destination, method = "libcurl",
                                          mode = "wb", quiet = quiet),
                      warning = identity, error = identity)
  if (!identical(status, 0L)) {
    reason <- if (inherits(status, "condition")) conditionMessage(status) else {
      "The download did not complete."
    }
    stop("Could not download the archive: ", reason, "\nSource: ", url, call. = FALSE)
  }
}

.asa_read_archive <- function(archive, metadata, source = "auto") {
  contents <- tryCatch(suppressWarnings(utils::unzip(archive, list = TRUE)),
                       error = function(e) NULL)
  if (source == "auto") {
    source <- if (metadata$file %in% contents$Name) "wiley" else "ucla"
  }
  expected <- if (source == "wiley") metadata$file else metadata$ucla_file
  if (is.null(contents) || !nzchar(expected) || sum(contents$Name == expected) != 1L) {
    stop("Archive does not contain the expected file for '", metadata$dataset,
         "'. Use refresh = TRUE to download it again: ", archive, call. = FALSE)
  }
  scratch <- tempfile("asa-extract-")
  dir.create(scratch)
  on.exit(unlink(scratch, recursive = TRUE), add = TRUE)
  tryCatch(utils::unzip(archive, files = expected, exdir = scratch),
           warning = function(w) stop("Cannot extract the dataset: ", conditionMessage(w), call. = FALSE),
           error = function(e) stop("Cannot extract the dataset: ", conditionMessage(e), call. = FALSE))
  file <- file.path(scratch, expected)
  if (source == "wiley") .asa_read_file(file, metadata) else .asa_read_spss(file, metadata)
}

.asa_checksum <- function(file, metadata, checksums) {
  actual <- unname(tools::md5sum(file))
  if (is.na(actual) || !actual %in% checksums) {
    stop("Source checksum differs from the recorded version for '", metadata$dataset,
         "'. The file may be damaged or changed. For a cached download, try refresh = TRUE.",
         call. = FALSE)
  }
}

.asa_schema <- function(metadata) {
  schema <- utils::read.csv(system.file("metadata", "schema.csv", package = "asaData",
                                       mustWork = TRUE), stringsAsFactors = FALSE)
  schema[schema$dataset == metadata$dataset, , drop = FALSE]
}

.asa_read_file <- function(file, metadata) {
  .asa_checksum(file, metadata, c(metadata$md5, metadata$first_edition_md5))
  schema <- .asa_schema(metadata)
  raw <- utils::read.table(file, header = FALSE, colClasses = "character",
                           na.strings = ".", quote = "", comment.char = "",
                           col.names = schema$variable, row.names = NULL,
                           check.names = FALSE)
  .asa_convert(raw, metadata, schema)
}

.asa_read_spss <- function(file, metadata) {
  if (!nzchar(metadata$ucla_file)) {
    stop("No verified UCLA copy is available for '", metadata$dataset, "'.", call. = FALSE)
  }
  .asa_checksum(file, metadata, metadata$ucla_md5)
  raw <- foreign::read.spss(file, use.value.labels = FALSE, to.data.frame = TRUE,
                            use.missings = TRUE, reencode = FALSE)
  schema <- .asa_schema(metadata)
  raw <- .asa_normalize_spss(raw, metadata, schema)
  .asa_convert(raw, metadata, schema)
}

.asa_normalize_spss <- function(raw, metadata, schema) {
  old_locale <- Sys.getlocale("LC_TIME")
  on.exit(Sys.setlocale("LC_TIME", old_locale), add = TRUE)
  if (!nzchar(Sys.setlocale("LC_TIME", "C"))) {
    stop("Cannot select English month names for date conversion.", call. = FALSE)
  }
  names(raw) <- tolower(names(raw))
  if (metadata$dataset == "uis") {
    names(raw)[names(raw) == "becktota"] <- "beck"
    raw$beck <- round(raw$beck, 3L)
  }
  if (metadata$dataset == "whas100") {
    rename <- c(addate = "admitdate", hosstay = "los", foltime = "lenfol",
                folstatus = "fstat")
    replace <- names(raw) %in% names(rename)
    names(raw)[replace] <- unname(rename[names(raw)[replace]])
    raw <- raw[order(raw$id), , drop = FALSE]
  }
  if (metadata$dataset %in% c("whas100", "whas500")) raw$bmi <- round(raw$bmi, 5L)
  if (anyDuplicated(names(raw)) || !setequal(names(raw), schema$variable)) {
    stop("Unexpected UCLA variables for '", metadata$dataset, "'.", call. = FALSE)
  }
  result <- lapply(seq_len(nrow(schema)), function(j) {
    value <- raw[[schema$variable[j]]]
    if (schema$storage[j] == "Date") {
      # SPSS stores dates as seconds since 14 October 1582; WHAS100 uses text.
      date <- if (is.character(value)) {
        as.Date(trimws(value), "%m/%d/%y")
      } else {
        as.Date(value / 86400, origin = "1582-10-14")
      }
      if (!identical(is.na(date), is.na(value))) {
        stop("Invalid UCLA dates for '", metadata$dataset, "'.", call. = FALSE)
      }
      return(format(date, schema$date_format[j]))
    }
    as.character(value)
  })
  names(result) <- schema$variable
  as.data.frame(result, stringsAsFactors = FALSE)
}

.asa_convert <- function(raw, metadata, schema) {
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
