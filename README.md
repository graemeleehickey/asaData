# hoslemSurv <img src="man/figures/logo.png" align="right" width="160" alt="hoslemSurv hex sticker" />

[![R package checks](https://github.com/graemeleehickey/hoslemSurv/actions/workflows/R-CMD-check.yaml/badge.svg?branch=main)](https://github.com/graemeleehickey/hoslemSurv/actions/workflows/R-CMD-check.yaml)
[![R version](https://img.shields.io/badge/R-%3E%3D%203.5.0-276DC3)](https://www.r-project.org/)
[![Datasets](https://img.shields.io/badge/datasets-16-006D77)](#datasets)
[![Code licence: CC0](https://img.shields.io/badge/code_licence-CC0-444444)](LICENSE)

**Author: Graeme L. Hickey**

`hoslemSurv` contains 16 datasets from both editions of *Applied Survival Analysis: Regression Modeling of Time to Event Data*: Hosmer and Lemeshow (1999), and Hosmer, Lemeshow, and May (2008). Each dataset has a help page describing its variables, coding, units, and book edition. The package has no analysis functions or runtime package dependencies.

## Installation

```r
install.packages("remotes") # If needed
remotes::install_github("graemeleehickey/hoslemSurv")
```

## Use

```r
library(hoslemSurv)
data(package = "hoslemSurv")
data("whas500", package = "hoslemSurv")
help("whas500", package = "hoslemSurv")
head(whas500)

# Optional analysis using the separately installed survival package
survival::survfit(survival::Surv(lenfol, fstat) ~ gender,
                  data = whas500)
```

Variable names are lower case, category codes are numeric, calendar dates are R `Date` objects, and source missing-value dots become `NA`.

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

`recur` and `uis` each represent both editions. `uis` uses the second-edition name `beck`; the help page explains the differences in the codebooks. `whasncc_e1` and `whasncc_e2` remain separate because their records and variables differ. All other dataset names omit edition suffixes; the edition is identified in the table and help page.

## Original files and sources

All 18 original data files and their codebooks are included with the installed package. Locate them using:

```r
system.file("extdata", package = "hoslemSurv")
system.file("extdata", "edition2", "whas500.dat", package = "hoslemSurv")
```

The [Wiley companion data site](https://ftp.wiley.com/public/sci_tech_med/survival/) is the original download location. The [UCLA companion page](https://stats.oarc.ucla.edu/other/examples/asa2/) provides SAS and SPSS downloads for selected second-edition datasets, with analysis examples for Stata, SPSS, and SAS.

The original files are stored under `inst/extdata/` in this repository. See [data-raw/README.md](data-raw/README.md) for the import and validation commands.

## Citation

Use `citation("hoslemSurv")` for the package and book references. Cite the relevant book edition and original study when using a dataset in research.

1. Hosmer, D. W., Jr. and Lemeshow, S. (1999). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. First edition. Wiley. ISBN 978-0-471-15410-5.
2. Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. Second edition. Wiley. DOI: [10.1002/9780470258019](https://doi.org/10.1002/9780470258019).

## Licence

Original package code, documentation, and artwork by Graeme L. Hickey are dedicated under [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/), to the extent of his rights in those contributions. Third-party datasets and codebooks retain their existing rights. Their redistribution terms remain to be clarified before CRAN submission. See [LICENSE](LICENSE).
