# Recreating the packaged data

**Author: Graeme L. Hickey**

The original data files and codebooks are stored in `inst/extdata/edition1/` and `inst/extdata/edition2/` and are included when the package is installed. Their contents are preserved byte for byte. The FRTCS codebook is named `FRTCS.txt`; its original filename contained a space before the extension.

`inst/extdata/manifest.csv` records all 18 source files, their editions, dataset names, dimensions, checksums, and source version. The `import` column selects one source per packaged dataset; `recur` and `uis` use the second-edition files. `inst/extdata/schema.csv` specifies the 175 variables across the 16 packaged datasets, their storage types, date formats, and expected missing-value counts.

Run these commands from the repository root:

```r
source("data-raw/import.R")
roxygen2::roxygenise()
source("data-raw/validate.R")
source("data-raw/verify-gbcs.R") # Optional label comparison; requires TH.data
```

The import verifies source checksums, preserves row order and numeric values, uses lower-case names, converts source missing-value dots to `NA`, and parses calendar dates. Validation compares every packaged value against the original files from both editions and checks the variable documentation. Installed-package checks also verify the original files through `system.file()`.

`verify-gbcs.R` verifies the GBCS menopausal-status and hormone-therapy labels against `TH.data::GBSG2`, matching records using six baseline variables and comparing recurrence times. The remaining data checks are in `tests/data-integrity.R`.
