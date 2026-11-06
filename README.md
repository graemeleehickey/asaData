# asaData <img src="man/figures/logo.png" align="right" width="160" alt="asaData hex sticker" />

[![R package checks](https://github.com/graemeleehickey/asaData/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/graemeleehickey/asaData/actions/workflows/R-CMD-check.yaml)
[![R version](https://img.shields.io/badge/R-%3E%3D%203.5.0-276DC3)](https://www.r-project.org/)
[![Datasets](https://img.shields.io/badge/datasets-16-006D77)](#datasets)
[![Licence: GPL-3](https://img.shields.io/badge/licence-GPL--3-444444)](https://www.r-project.org/Licenses/GPL-3)

`asaData` is an unofficial companion package to the first and second editions of *Applied Survival Analysis: Regression Modeling of Time to Event Data* by Hosmer and Lemeshow (1999), and Hosmer, Lemeshow, and May (2008). It downloads 16 datasets from Wiley, offers verified UCLA alternatives for six datasets, and imports saved files or ZIP archives offline. Each dataset has a help page describing its variables, units, and book edition. No dataset records or original codebooks are bundled, and nothing is downloaded during installation or when the package is loaded. UCLA imports use `foreign`, a recommended package included with standard R installations.

## Installation

```r
install.packages("remotes") # If needed
remotes::install_github("graemeleehickey/asaData")
```

## Use

Download and load all 16 datasets in one call:

```r
library(asaData)
datasets <- download_asa_all()
head(datasets$whas500)

# Optional: create separate objects in your workspace
list2env(datasets, envir = .GlobalEnv)
```

`download_asa_all()` returns a named list and downloads each required archive at most once. Use `cache_dir = "~/asaData-cache"` to keep archives between sessions or `refresh = TRUE` to replace cached copies. If any dataset cannot be loaded, the call stops with an error naming that dataset and returns no partial list; successful downloads remain cached. UCLA alone cannot supply all 16 datasets.

To download an individual dataset:

```r
library(asaData)
asa_datasets()
whas500 <- download_asa("whas500")
help("whas500", package = "asaData")
head(whas500)

# Survival analysis example
library(survival)
survfit(Surv(lenfol, fstat) ~ gender, data = whas500)
```

The default `source = "auto"` reuses cached archives, preferring Wiley. If a download is needed, it tries Wiley, then a verified UCLA alternative if Wiley fails. UCLA is supported for `bpd`, `gbcs`, `grace1000`, `uis`, `whas100`, and `whas500`; automatic use of UCLA is reported in a message. By default, downloads are kept only for the current R session. Each import checks the source checksum, dimensions, missing-value counts, and variable types. Changed or damaged files are rejected.

Variable names are lower case, category codes are numeric, calendar dates are R `Date` objects, and missing values become `NA`. The six UCLA alternatives are converted to reproduce Wiley's values, variable types, and row order exactly.

```r
# Reuse the second-edition archive
gbcs <- download_asa("gbcs")

# Optionally keep downloads between R sessions
whas500 <- download_asa("whas500", cache_dir = "~/asaData-cache")

# Replace a damaged cached archive
whas500 <- download_asa("whas500", refresh = TRUE)

# Choose a source explicitly
whas500 <- download_asa("whas500", source = "ucla")
whas500 <- download_asa("whas500", source = "wiley")
```

## Use saved copies offline

Download the [first-edition ZIP](https://ftp.wiley.com/public/sci_tech_med/survival/First-Edition%20Data.zip) and [second-edition ZIP](https://ftp.wiley.com/public/sci_tech_med/survival/Second-Edition%20Data.zip) yourself, then import all 16 datasets in one call. The archives do not need to be extracted.

```r
datasets <- read_asa_all(c("path/to/First-Edition Data.zip",
                          "path/to/Second-Edition Data.zip"))
names(datasets)
head(datasets$whas500)

# Or point to a folder containing both ZIP archives
datasets <- read_asa_all("~/Downloads/asa-data")

# Optional: create separate objects such as whas500, gbcs, and uis
list2env(datasets, envir = .GlobalEnv)
```

`read_asa_all()` returns a named list containing the supported datasets found in the supplied archives or folders: five for the first edition, thirteen for the second edition, or all 16 when both editions are supplied. Shared datasets appear once. A [UCLA SPSS ZIP](https://stats.oarc.ucla.edu/wp-content/uploads/2016/02/asa2_spss.zip) supplies the six verified alternatives. Subfolders are not searched; keep extracted editions in separate folders and pass both paths if needed. Recognised files with invalid checksums stop the import. Nothing is downloaded or assigned to your workspace automatically.

For a single dataset, supply an original data file, a saved ZIP, or a folder containing the expected files:

```r
whas500 <- read_asa("whas500", "path/to/whas500.dat")
whas500 <- read_asa("whas500", "path/to/Second-Edition Data.zip")
whas500 <- read_asa("whas500", "~/asaData-cache")
whas500 <- read_asa("whas500", "path/to/asa2_spss.zip")
```

Local imports apply the same checks as downloads. Edited files and changed line endings may fail the checksum check. Either edition's original `recur` and `uis` files is accepted; the returned names follow the second edition. The WHAS nested case-control samples remain distinct.

The [reference manual](https://github.com/graemeleehickey/asaData/blob/main/asaData-reference-manual.pdf) contains the package and dataset help pages.

## Analysis examples

The help pages for `whas100`, `bpd`, `actg320`, `gbcs`, `uis`, `whas500`, and `grace1000` include examples using `survival`, a recommended package included with standard R installations. The [Survival analysis examples vignette](https://github.com/graemeleehickey/asaData/blob/main/vignettes/survival-examples.Rmd) covers interactions, proportional-hazards diagnostics, time-dependent covariates, and parametric models, with comparisons against selected second-edition results presented by UCLA.

```r
library(survival)
example("actg320", package = "asaData", run.dontrun = TRUE)

# Build the vignette (displays code without downloading or running analyses)
remotes::install_github("graemeleehickey/asaData",
                        dependencies = TRUE, build_vignettes = TRUE)
vignette("survival-examples", package = "asaData")
```

## Datasets

| Dataset | Edition | Rows | Variables | Description |
|---|---:|---:|---:|---|
| `hmohiv` | 1 | 100 | 7 | Hypothetical HMO-HIV Study |
| `whas` | 1 | 481 | 14 | Worcester Heart Attack Study |
| `whasncc_e1` | 1 | 1,494 | 12 | WHAS Nested Case-Control Sample |
| `actg320` | 2 | 1,151 | 16 | ACTG 320 Trial |
| `actg320ncc` | 2 | 576 | 7 | ACTG 320 Nested Case-Control Sample |
| `bpd` | 2 | 78 | 4 | Bronchopulmonary Dysplasia Data |
| `comprisk` | 2 | 453 | 6 | Competing-Risks Exercise |
| `cvdrisk` | 2 | 65 | 6 | Cardiovascular Competing-Risks Example |
| `frtcs` | 2 | 697 | 17 | French Three Cities Study |
| `gbcs` | 2 | 686 | 16 | German Breast Cancer Study |
| `grace1000` | 2 | 1,000 | 9 | GRACE Acute Coronary Syndrome Data |
| `recur` | 1 and 2 | 1,296 | 7 | Recurrent Soreness Episodes |
| `uis` | 1 and 2 | 628 | 12 | UMass Impact Study of Drug Treatment |
| `whas100` | 2 | 100 | 9 | WHAS 100-Patient Dataset |
| `whas500` | 2 | 500 | 22 | WHAS 500-Patient Dataset |
| `whasncc_e2` | 2 | 1,638 | 11 | WHAS Nested Case-Control Sample |

Each row represents an observation. The recurrent-event data contain multiple intervals per participant, and the nested case-control data contain sampled risk-set records.

The shared `recur` and `uis` datasets follow the second-edition definitions; their values agree with the first-edition copies. `uis` uses the second-edition name `beck`; its help page explains the codebook differences. The editions have different WHAS nested case-control samples, accessed as `whasncc_e1` and `whasncc_e2`. All other dataset names omit edition suffixes; the edition is identified in the table and help page.

## Sources and checks

The [Wiley companion data site](https://ftp.wiley.com/public/sci_tech_med/survival/) provides the original edition archives. The [UCLA companion page](https://stats.oarc.ucla.edu/other/examples/asa2/) provides SPSS and SAS copies and analysis examples. UCLA fallback uses only the six verified SPSS copies. Its ACTG SPSS file omits two outcomes, so it is not substituted. UCLA imports restore Wiley's variable names and dates, WHAS100 row order, UIS Beck scores to three decimal places, and WHAS BMI values to five decimal places. All returned values have been compared with the original Wiley files.

The package retains a file catalogue, source checksums, and variable definitions under `inst/metadata/`. Routine package checks use synthetic records without internet access. Optional checks compare batch imports, UCLA copies, and analysis results using separately downloaded archives; see the [validation instructions](data-raw/README.md).

## Citation

Use `citation("asaData")` for the package and book references. Cite the relevant book edition and original study when using a dataset in research.

1. Hosmer, D. W., Jr. and Lemeshow, S. (1999). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. First edition. Wiley. ISBN 978-0-471-15410-5.
2. Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. Second edition. Wiley. DOI: [10.1002/9780470258019](https://doi.org/10.1002/9780470258019).

## Licence

Package code and original documentation by Graeme L. Hickey are distributed under the [GNU General Public License, version 3 (GPL-3)](https://www.r-project.org/Licenses/GPL-3).
