# hoslemSurv

**Author: Graeme L. Hickey**

`hoslemSurv` contains the datasets supplied with both editions of *Applied Survival Analysis: Regression Modeling of Time to Event Data*: Hosmer and Lemeshow (1999), and Hosmer, Lemeshow, and May (2008). It is an unofficial data-only companion package, with 16 documented datasets covering all 18 source data files and no analysis functions or runtime package dependencies.

## Installation

```r
install.packages("remotes") # If needed
remotes::install_github("graemeleehickey/hoslemSurv")
```

## Use

```r
library(hoslemSurv)
data(package = "hoslemSurv")
data("whas500_e2", package = "hoslemSurv")
help("whas500_e2", package = "hoslemSurv")
head(whas500_e2)

# Optional analysis using the separately installed survival package
survival::survfit(survival::Surv(lenfol, fstat) ~ gender,
                  data = whas500_e2)
```

The shared datasets `recur` and `uis` represent both editions, using second-edition variable names. Other names end in `_e1` or `_e2` to identify the edition. Variable names are lower case, numeric category codes remain numeric, dates are R `Date` objects, and source missing-value dots become `NA`. Every source row and numeric value is retained. The help page for each dataset describes its observation unit, variables, units, codes, endpoints, missing values, and known source discrepancies.

## Datasets

| Dataset | Edition | Rows | Variables | Description |
|---|---:|---:|---:|---|
| `hmohiv_e1` | 1 | 100 | 7 | Hypothetical HMO-HIV Study |
| `whas_e1` | 1 | 481 | 14 | Worcester Heart Attack Study |
| `whasncc_e1` | 1 | 1,494 | 12 | WHAS Nested Case-Control Sample |
| `actg320_e2` | 2 | 1,151 | 16 | ACTG 320 Trial |
| `actg320ncc_e2` | 2 | 576 | 7 | ACTG 320 Nested Case-Control Sample |
| `bpd_e2` | 2 | 78 | 4 | Bronchopulmonary Dysplasia Data |
| `comprisk_e2` | 2 | 453 | 6 | Competing-Risks Exercise |
| `cvdrisk_e2` | 2 | 65 | 6 | Cardiovascular Competing-Risks Example |
| `frtcs_e2` | 2 | 697 | 17 | French Three Cities Study |
| `gbcs_e2` | 2 | 686 | 16 | German Breast Cancer Study |
| `grace1000_e2` | 2 | 1,000 | 9 | GRACE Acute Coronary Syndrome Data |
| `recur` | 1 and 2 | 1,296 | 7 | Recurrent Soreness Episodes |
| `uis` | 1 and 2 | 628 | 12 | UMass Impact Study of Drug Treatment |
| `whas100_e2` | 2 | 100 | 9 | WHAS 100-Patient Dataset |
| `whas500_e2` | 2 | 500 | 22 | WHAS 500-Patient Dataset |
| `whasncc_e2` | 2 | 1,638 | 11 | WHAS Nested Case-Control Sample |

Rows are observations, not necessarily distinct participants. The recurrent-event datasets contain multiple intervals per participant, and the nested case-control datasets contain sampled risk-set records.

## Source conventions and discrepancies

- The two editions share one `recur` dataset and one `uis` dataset because their values are identical. `uis` uses the second-edition name `beck` for the column called `becktota` in edition 1. Both source editions and their documentation are preserved in `data-raw/`, and edition differences are described in the help pages.
- The two `whasncc` versions contain different sampled records and variables: 1,494 rows and 12 variables in edition 1, versus 1,638 rows and 11 variables in edition 2. Edition 2 includes `bmi` but omits `yrgrp` and `lenstay`.
- `hmohiv_e1$time` is in approximate months, despite the source codebook saying days. All 100 values agree with rounded calendar follow-up in months.
- `gbcs_e2$menopause` and `hormone` use `1/2`, despite the source codebook saying `0/1`. All 686 records were matched to `TH.data::GBSG2` to verify the labels. Code 1 means premenopausal/no hormone therapy; code 2 means postmenopausal/hormone therapy.
- The UIS codebooks give different descriptions of loss to follow-up despite identical event indicators. The FRTCS visit labels are inconsistent, and some endpoint definitions and measurement units are incomplete. Dataset help pages distinguish documented definitions, verified corrections, and unresolved interpretations.
- Potentially unusual source values, including zero blood pressure in `grace1000_e2`, are retained and documented. Missing risk-set sizes in the WHAS nested case-control datasets remain missing.

## Provenance and reproduction

The original `.dat` files and variable descriptions are retained under `data-raw/edition1/` and `data-raw/edition2/`. They are copied byte for byte from [graemeleehickey/hosmer-lemeshow](https://github.com/graemeleehickey/hosmer-lemeshow/tree/59a56c509c81898d3853763afcf71686234a1326), commit `59a56c509c81898d3853763afcf71686234a1326`. The source repository identifies the [Wiley companion data site](https://ftp.wiley.com/public/sci_tech_med/survival/) as the original download location. No other package supplies the data distributed here.

The [UCLA second-edition companion page](https://stats.oarc.ucla.edu/other/examples/asa2/) provides freely downloadable data in SAS and SPSS formats, with analysis examples for Stata, SPSS, and SAS. These provide additional resources for reproducing the book's analyses.

From the repository root:

```r
source("data-raw/import.R")       # Verify source checksums and recreate data/*.rda
source("data-raw/validate.R")     # Compare every imported value with its source
roxygen2::roxygenise()            # Recreate help pages from R/*.R
```

`data-raw/verify-gbcs.R` reproduces the independent GBCS code-label comparison when `TH.data` is installed. See [data-raw/README.md](data-raw/README.md) for the source-file inventory and verification details.

```sh
R CMD build .
R CMD check --as-cran hoslemSurv_0.1.0.tar.gz
```

## Citation

Use `citation("hoslemSurv")` for the package and book references. Cite the relevant book edition and original study when using a dataset in research.

1. Hosmer, D. W., Jr. and Lemeshow, S. (1999). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. First edition. Wiley. ISBN 978-0-471-15410-5.
2. Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). *Applied Survival Analysis: Regression Modeling of Time to Event Data*. Second edition. Wiley. DOI: [10.1002/9780470258019](https://doi.org/10.1002/9780470258019).

The first-edition source codebooks cite 1998; the published edition is cited here as 1999. Susanne May is a coauthor of the second edition.

## Licence

Original package code and documentation by Graeme L. Hickey are dedicated under [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/), to the extent of his rights in those contributions. CC0 permits reuse without an attribution condition, including commercial reuse. The third-party datasets and original codebooks retain their existing rights; the source repository provides no explicit dataset licence. This package does not assign a new licence to those materials, and their availability for download does not establish redistribution terms. Redistribution terms remain to be clarified before a CRAN submission. See [LICENSE](LICENSE).
