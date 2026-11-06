# Validating imports

**Author: Graeme L. Hickey**

The package downloads Wiley archives, with verified UCLA alternatives for six datasets, and imports local files or archives. It does not include dataset records or original codebooks. `inst/metadata/manifest.csv` lists the 16 supported datasets, their source editions, archive URLs, filenames, dimensions, and MD5 checksums for each supported source. `inst/metadata/schema.csv` records the 175 variables, storage types, date formats, and missing-value counts. `recur` and `uis` download from the second edition; either edition's original file is accepted locally because the values agree.

Routine `R CMD check` runs synthetic-file tests without contacting either site. These cover downloads, fallback, archive reuse, refresh failures, checksum rejection, batch imports, malformed input, date conversion, numeric precision, and missing-value handling. Dataset help pages and the vignette display download examples without running them automatically.

For checks against the original data, install the current package and run the following from the repository root. `download_asa_all()` downloads each Wiley archive once. Keep the archive directory outside the repository.

```r
library(asaData)
archive_dir <- file.path(tempdir(), "asaData-validation")
invisible(download_asa_all(cache_dir = archive_dir, source = "wiley"))
invisible(download_asa("whas500", cache_dir = archive_dir, source = "ucla"))
Sys.setenv(ASADATA_TEST_ARCHIVES = archive_dir)
Sys.setenv(ASADATA_TEST_UCLA_ARCHIVE = file.path(archive_dir, "ucla-asa2-spss.zip"))
source("data-raw/validate.R")
source("tests/data-integrity.R")
source("tests/local-sources.R")
source("tests/download-all.R")
source("tests/analysis-examples.R") # Requires survival
source("data-raw/verify-gbcs.R")    # Optional; requires TH.data
```

`validate.R` independently compares every imported value with the source tokens and checks every documented variable name. The integrity checks cover edition differences, endpoints, dates, and missing values. `local-sources.R` checks imports of both editions together and separately, both editions' shared files, and exact equality of all six converted UCLA datasets with Wiley, including types and row order. UCLA conversions restore names and dates, sort WHAS100 by ID, round UIS Beck scores to three decimal places, and round WHAS BMI values to five decimal places. The analysis checks compare all seven help examples with the cited UCLA results. The optional GBCS comparison verifies menopausal-status and hormone-therapy labels against `TH.data::GBSG2` by matching records on six baseline variables and comparing recurrence times.

To render and check the complete vignette without downloading the same archives again, copy the two archives to its default session cache first:

```r
cache_dir <- file.path(tempdir(), "asaData")
dir.create(cache_dir, showWarnings = FALSE)
file.copy(file.path(archive_dir, c("edition1.zip", "edition2.zip")),
          cache_dir, overwrite = TRUE)
Sys.setenv(ASADATA_RUN_EXAMPLES = "true")
rmarkdown::render("vignettes/survival-examples.Rmd",
                  output_dir = tempdir())
Sys.unsetenv(c("ASADATA_TEST_ARCHIVES", "ASADATA_TEST_UCLA_ARCHIVE",
               "ASADATA_RUN_EXAMPLES"))
```

Regenerate help pages with `roxygen2::roxygenise()` and the reference manual with `R CMD Rd2pdf --no-preview --force --output=asaData-reference-manual.pdf .`. A regular `R CMD build .` and `R CMD check` require no data-source access. When updating a source version, verify the changed files, dimensions, variables, and analysis results before changing any recorded checksum.
