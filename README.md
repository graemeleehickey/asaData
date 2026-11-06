# asaData <img src="man/figures/logo.png" align="right" width="160" alt="asaData hex sticker" />

[![R package checks](https://github.com/graemeleehickey/asaData/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/graemeleehickey/asaData/actions/workflows/R-CMD-check.yaml)
[![R version](https://img.shields.io/badge/R-%3E%3D%203.5.0-276DC3)](https://www.r-project.org/)
[![Datasets](https://img.shields.io/badge/datasets-16-006D77)](#datasets)
[![Licence: GPL-3](https://img.shields.io/badge/licence-GPL--3-444444)](https://www.r-project.org/Licenses/GPL-3)

`asaData` is an unofficial companion package to the first and second editions of *Applied Survival Analysis: Regression Modeling of Time to Event Data* by Hosmer and Lemeshow (1999), and Hosmer, Lemeshow, and May (2008). It downloads and imports 16 datasets directly from Wiley, preserving the original values and coding. Each dataset has a help page describing its variables, units, and book edition. No dataset records or original codebooks are bundled, and nothing is downloaded during installation or when the package is loaded. The package has no runtime package dependencies.

## Installation

```r
install.packages("remotes") # If needed
remotes::install_github("graemeleehickey/asaData")
```

## Use

```r
library(asaData)
asa_datasets()
whas500 <- download_asa("whas500")
help("whas500", package = "asaData")
head(whas500)

# Optional analysis using the separately installed survival package
survival::survfit(survival::Surv(lenfol, fstat) ~ gender,
                  data = whas500)
```

The first request downloads the relevant edition archive over HTTPS. Further requests from that edition reuse the archive. By default, downloads are kept only for the current R session. Each import checks the source checksum, dimensions, missing-value counts, and variable types. Changed or damaged files are rejected.

Variable names are lower case, category codes are numeric, calendar dates are R `Date` objects, and source missing-value dots become `NA`. Row order and numeric values are preserved.

```r
# Reuse the second-edition archive
gbcs <- download_asa("gbcs")

# Optionally keep downloads between R sessions
whas500 <- download_asa("whas500", cache_dir = "~/asaData-cache")

# Replace a damaged cached archive
whas500 <- download_asa("whas500", refresh = TRUE)

# Or read an original .dat file you have already downloaded and extracted
whas500 <- read_asa("whas500", "path/to/whas500.dat")
```

Use the second-edition files for `recur` and `uis`. `read_asa()` applies the same source checks as `download_asa()`; edited files, files from another edition, and changed line endings may fail the checksum check.

The [reference manual](https://github.com/graemeleehickey/asaData/blob/main/asaData-reference-manual.pdf) contains the package and dataset help pages.

## Analysis examples

The help pages for `whas100`, `bpd`, `actg320`, `gbcs`, `uis`, `whas500`, and `grace1000` include examples using the optional `survival` package. The [Survival analysis examples vignette](https://github.com/graemeleehickey/asaData/blob/main/vignettes/survival-examples.Rmd) covers interactions, proportional-hazards diagnostics, time-dependent covariates, and parametric models, with comparisons against selected second-edition results presented by UCLA.

```r
# Install the optional analysis package if needed
install.packages("survival")
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

The shared `recur` and `uis` datasets use the second-edition files, whose values agree with the first-edition copies. `uis` uses the second-edition name `beck`; its help page explains the codebook differences. The editions have different WHAS nested case-control samples, accessed as `whasncc_e1` and `whasncc_e2`. All other dataset names omit edition suffixes; the edition is identified in the table and help page.

## Sources and checks

The [Wiley companion data site](https://ftp.wiley.com/public/sci_tech_med/survival/) provides first- and second-edition ZIP archives containing the original data files and codebooks. `download_asa()` retrieves these archives directly from Wiley. The [UCLA companion page](https://stats.oarc.ucla.edu/other/examples/asa2/) provides other download formats and analysis examples; it is not used as a download source by this package.

The package retains a file catalogue, source checksums, and variable definitions under `inst/metadata/`. Routine package checks use synthetic files and do not contact Wiley. Optional checks compare imports and analysis results using separately downloaded archives; see the [validation instructions](data-raw/README.md).

## Citation

Use `citation("asaData")` for the package and book references. Cite the relevant book edition and original study when using a dataset in research.

1. Hosmer, D. W., Jr. and Lemeshow, S. (1999). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. First edition. Wiley. ISBN 978-0-471-15410-5.
2. Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. Second edition. Wiley. DOI: [10.1002/9780470258019](https://doi.org/10.1002/9780470258019).

## Licence

Package code and original documentation by Graeme L. Hickey are distributed under the [GNU General Public License, version 3 (GPL-3)](https://www.r-project.org/Licenses/GPL-3). This licence does not apply to downloaded datasets or codebooks. Those materials retain their existing rights; consult [Wiley’s terms](https://www.wiley.com/en-us/legal/terms) before downloading or reusing them.
