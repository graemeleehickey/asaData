# asaData <img src="man/figures/logo.png" align="right" width="160" alt="asaData hex sticker" />

[![R package checks](https://github.com/graemeleehickey/asaData/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/graemeleehickey/asaData/actions/workflows/R-CMD-check.yaml)
[![R version](https://img.shields.io/badge/R-%3E%3D%203.5.0-276DC3)](https://www.r-project.org/)
[![Datasets](https://img.shields.io/badge/datasets-16-006D77)](#datasets)
[![Licence: GPL-3](https://img.shields.io/badge/licence-GPL--3-444444)](LICENSE.md)

**Author: Graeme L. Hickey**

`asaData` is an unofficial companion package to the first and second editions of *Applied Survival Analysis: Regression Modeling of Time to Event Data* by Hosmer and Lemeshow (1999), and Hosmer, Lemeshow, and May (2008). It contains 16 datasets from the two editions. Each dataset has a help page describing its variables, coding, units, and book edition. The package has no analysis functions or runtime package dependencies.

## Installation

```r
install.packages("remotes") # If needed
remotes::install_github("graemeleehickey/asaData")
```

## Use

```r
library(asaData)
data(package = "asaData")
data("whas500", package = "asaData")
help("whas500", package = "asaData")
head(whas500)

# Optional analysis using the separately installed survival package
survival::survfit(survival::Surv(lenfol, fstat) ~ gender,
                  data = whas500)
```

Variable names are lower case, category codes are numeric, calendar dates are R `Date` objects, and source missing-value dots become `NA`.

## Analysis examples

The help pages for `whas100`, `bpd`, `actg320`, `gbcs`, `uis`, `whas500`, and `grace1000` include examples using the optional `survival` package. The [Survival analysis examples vignette](vignettes/survival-examples.Rmd) covers interactions, proportional-hazards diagnostics, time-dependent covariates, and parametric models, with comparisons against selected second-edition results presented by UCLA.

```r
# Install the optional analysis package if needed
install.packages("survival")
example("actg320", package = "asaData")

# Build the vignette when installing from GitHub
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

The `recur` and `uis` datasets are extracted from the second-edition of the book, but are essentially the same as the first-edition copies. `uis` uses the second-edition name `beck`; the help page explains the differences in the codebooks. The `whasncc` dataset is different between the first and second edition of the book, and therefore both copies are kept. All other dataset names omit edition suffixes; the edition is identified in the table and help page.

## Original files and sources

All 18 original data files and their codebooks are included with the installed package. Locate them using:

```r
system.file("extdata", package = "asaData")
system.file("extdata", "edition2", "whas500.dat", package = "asaData")
```

The [Wiley companion data site](https://ftp.wiley.com/public/sci_tech_med/survival/) is the original download location. The [UCLA companion page](https://stats.oarc.ucla.edu/other/examples/asa2/) provides SAS and SPSS downloads for selected second-edition datasets, with analysis examples for Stata, SPSS, and SAS.

The original files are stored under `inst/extdata/` in this repository. See [data-raw/README.md](data-raw/README.md) for the import and validation commands.

## Citation

Use `citation("asaData")` for the package and book references. Cite the relevant book edition and original study when using a dataset in research.

1. Hosmer, D. W., Jr. and Lemeshow, S. (1999). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. First edition. Wiley. ISBN 978-0-471-15410-5.
2. Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. Second edition. Wiley. DOI: [10.1002/9780470258019](https://doi.org/10.1002/9780470258019).

## Licence

`asaData` is distributed under the [GNU General Public License, version 3 (GPL-3)](LICENSE.md). Third-party datasets and codebooks retain their existing rights. Their redistribution terms remain to be clarified before CRAN submission.
