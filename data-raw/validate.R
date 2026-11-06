# Independently compare every imported value with separately downloaded Wiley files.
# Run from the repository root with the current package installed.
local({
  cache_dir <- Sys.getenv("ASADATA_TEST_ARCHIVES")
  if (!nzchar(cache_dir)) stop("Set ASADATA_TEST_ARCHIVES to the directory containing edition1.zip and edition2.zip.")
  stopifnot(all(file.exists(file.path(cache_dir, c("edition1.zip", "edition2.zip")))))
  manifest <- asaData::asa_datasets()
  schema <- read.csv("inst/metadata/schema.csv", stringsAsFactors = FALSE)
  stopifnot(nrow(manifest) == 16L, !anyDuplicated(manifest$dataset),
            setequal(schema$dataset, manifest$dataset))
  old_locale <- Sys.getlocale("LC_TIME")
  on.exit(Sys.setlocale("LC_TIME", old_locale), add = TRUE)
  Sys.setlocale("LC_TIME", "C")
  scratch <- tempfile("asa-validate-")
  dir.create(scratch)
  on.exit(unlink(scratch, recursive = TRUE), add = TRUE)
  all_cells <- 0L
  for (i in seq_len(nrow(manifest))) {
    m <- manifest[i, ]
    s <- schema[schema$dataset == m$dataset, ]
    archive <- file.path(cache_dir, paste0("edition", m$edition, ".zip"))
    utils::unzip(archive, files = m$file, exdir = scratch, overwrite = TRUE)
    file <- file.path(scratch, m$file)
    stopifnot(identical(unname(tools::md5sum(file)), m$md5))
    tokens <- scan(file, what = character(), quiet = TRUE)
    stopifnot(length(tokens) == m$rows * m$columns)
    raw <- matrix(tokens, ncol = m$columns, byrow = TRUE)
    x <- asaData::download_asa(m$dataset, cache_dir = cache_dir)
    stopifnot(identical(x, asaData::read_asa(m$dataset, file)),
              nrow(x) == m$rows, ncol(x) == m$columns,
              identical(names(x), s$variable),
              identical(as.integer(colSums(is.na(x))), as.integer(s$missing)))
    for (j in seq_len(ncol(x))) {
      missing <- raw[, j] == "."
      stopifnot(identical(is.na(x[[j]]), missing))
      if (s$storage[j] == "Date") {
        stopifnot(inherits(x[[j]], "Date"),
                  identical(tolower(format(x[[j]][!missing], s$date_format[j])),
                            tolower(raw[!missing, j])))
      } else {
        stopifnot(identical(typeof(x[[j]]), s$storage[j]),
                  identical(as.numeric(x[[j]][!missing]), as.numeric(raw[!missing, j])))
      }
    }
    rd <- tools::parse_Rd(file.path("man", paste0(m$dataset, ".Rd")))
    format_section <- Filter(function(z) identical(attr(z, "Rd_tag"), "\\format"), rd)
    items <- Filter(function(z) identical(attr(z, "Rd_tag"), "\\describe"), format_section[[1L]])
    variable_items <- Filter(function(z) identical(attr(z, "Rd_tag"), "\\item"), items[[1L]])
    documented <- vapply(variable_items, function(z) paste(unlist(z[[1L]]), collapse = ""), character(1))
    stopifnot(identical(documented, names(x)))
    all_cells <- all_cells + nrow(x) * ncol(x)
  }
  message("Verified ", nrow(manifest), " datasets, ", all_cells,
          " source values, and all ", nrow(schema), " variable definitions.")
})
