# Validating imports

**Author: Graeme L. Hickey**

The package downloads original Wiley ZIP archives when requested. It does not include dataset records or original codebooks. `inst/metadata/manifest.csv` lists the 16 supported datasets, their source editions, archive URLs, filenames, dimensions, and MD5 checksums. `inst/metadata/schema.csv` records the 175 variables, storage types, date formats, and missing-value counts. `recur` and `uis` use the second-edition files; their first-edition values agree.

Routine `R CMD check` runs synthetic-file tests without contacting Wiley. These cover downloads, archive reuse, refresh failures, checksum rejection, malformed input, date conversion, and missing-value handling. Dataset help pages and the vignette display download examples without running them automatically.

For checks against the original data, install the current package and run the following from the repository root. The first two calls download each Wiley archive once. Keep the archive directory outside the repository.

```r
library(asaData)
archive_dir <- file.path(tempdir(), "asaData-validation")
invisible(download_asa("hmohiv", cache_dir = archive_dir))
invisible(download_asa("whas500", cache_dir = archive_dir))
Sys.setenv(ASADATA_TEST_ARCHIVES = archive_dir)
source("data-raw/validate.R")
source("tests/data-integrity.R")
source("tests/analysis-examples.R") # Requires survival
source("data-raw/verify-gbcs.R")    # Optional; requires TH.data
```

`validate.R` independently compares every imported value with the source tokens and checks every documented variable name. The integrity checks cover edition differences, endpoints, dates, and missing values. The analysis checks compare all seven help examples with the cited UCLA results. The optional GBCS comparison verifies menopausal-status and hormone-therapy labels against `TH.data::GBSG2` by matching records on six baseline variables and comparing recurrence times.

To render and check the complete vignette without downloading the same archives again, copy the two archives to its default session cache first:

```r
cache_dir <- file.path(tempdir(), "asaData")
dir.create(cache_dir, showWarnings = FALSE)
file.copy(file.path(archive_dir, c("edition1.zip", "edition2.zip")),
          cache_dir, overwrite = TRUE)
Sys.setenv(ASADATA_RUN_EXAMPLES = "true")
rmarkdown::render("vignettes/survival-examples.Rmd",
                  output_dir = tempdir())
Sys.unsetenv(c("ASADATA_TEST_ARCHIVES", "ASADATA_RUN_EXAMPLES"))
```

Regenerate help pages with `roxygen2::roxygenise()` and the reference manual with `R CMD Rd2pdf --no-preview --force --output=asaData-reference-manual.pdf .`. A regular `R CMD build .` and `R CMD check` require no Wiley access. When updating a source version, verify the changed files, dimensions, variables, and analysis results before changing any recorded checksum.
