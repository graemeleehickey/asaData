# Verify every packaged value against the preserved source, independently of import.R.
# Run from the package repository root: source("data-raw/validate.R").
local({
  manifest <- read.csv("data-raw/manifest.csv", stringsAsFactors = FALSE)
  schema <- read.csv("data-raw/schema.csv", stringsAsFactors = FALSE)
  datasets <- unique(manifest$dataset)
  selected <- manifest$dataset[manifest$import]
  stopifnot(nrow(manifest) == 18L, length(datasets) == 16L,
            !anyNA(manifest$import), !anyDuplicated(selected),
            setequal(selected, datasets), setequal(schema$dataset, datasets),
            setequal(list.files("data", pattern = "\\.rda$"), paste0(datasets, ".rda")))
  old_locale <- Sys.getlocale("LC_TIME")
  on.exit(Sys.setlocale("LC_TIME", old_locale), add = TRUE)
  Sys.setlocale("LC_TIME", "C")
  all_cells <- 0L
  for (i in seq_len(nrow(manifest))) {
    m <- manifest[i, ]
    s <- schema[schema$dataset == m$dataset, ]
    paths <- file.path("data-raw", c(m$data_file, m$codebook))
    stopifnot(identical(unname(tools::md5sum(paths)), c(m$data_md5, m$codebook_md5)))
    tokens <- scan(paths[1L], what = character(), quiet = TRUE)
    stopifnot(length(tokens) == m$rows * m$columns)
    raw <- matrix(tokens, ncol = m$columns, byrow = TRUE)
    e <- new.env()
    stopifnot(identical(load(file.path("data", paste0(m$dataset, ".rda")), envir = e), m$dataset))
    x <- e[[m$dataset]]
    stopifnot(is.data.frame(x), nrow(x) == m$rows, ncol(x) == m$columns,
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
  message("Verified ", length(datasets), " packaged datasets against ", nrow(manifest),
          " source files, ", all_cells, " source values, and all ", nrow(schema),
          " variable definitions.")
})
