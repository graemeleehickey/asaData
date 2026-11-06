# Source data and reproduction

**Author: Graeme L. Hickey**

The `edition1/` and `edition2/` directories contain unmodified source data and variable descriptions from [graemeleehickey/hosmer-lemeshow](https://github.com/graemeleehickey/hosmer-lemeshow), commit `59a56c509c81898d3853763afcf71686234a1326`, retrieved on 6 November 2026. The original filename `edition2/FRTCS .txt` includes a space before the extension and is retained exactly. These files are the source evidence, not disposable intermediate files.

`manifest.csv` records all 18 source data files, their edition, packaged dataset name, dimensions, MD5 checksums for the data and codebook, and source commit. Its `import` column selects one source file per packaged dataset: the second-edition files supply the shared `recur` and `uis` datasets. The first-edition files remain in the inventory for independent comparison. `schema.csv` records the 175 columns across the 16 packaged datasets in source order, including their R storage types, date formats, and expected missing-value counts. MD5 is used here to detect file changes; the Git commit identifies the upstream version.

Run the following from the package repository root:

```r
source("data-raw/import.R")
roxygen2::roxygenise()
source("data-raw/validate.R")
source("data-raw/verify-gbcs.R") # Optional independent check; requires TH.data
```

The import uses only base and recommended R packages. It verifies checksums for all source files and codebooks before selecting the files to import, checks dimensions and missing-value counts, uses explicit date formats with English month names, and rejects failed date conversions. It preserves the source row and column order, lowercases variable names, retains numeric coding, converts dots to `NA`, and saves compressed data frames in `data/`. Columns containing only whole numbers use integer storage; other numeric columns use double storage. It makes no corrections to data values.

The separate validation script reads all 18 original files independently, compares every numeric value (including both editions against the shared `recur` and `uis` datasets), checks all missing positions, and converts each packaged date back to its exact source representation. It also checks that every variable is documented in the corresponding help page. The installed-package tests check dataset dimensions and clinically relevant data relationships, including outcome coding, calendar durations, recurrent-event intervals, matched sets, and edition differences.

## Documentation evidence

- HMO-HIV: all 100 recorded times equal the rounded date difference divided by `365.25/12`, confirming approximate months despite the source codebook's days label. The recorded values are retained.
- GBCS: `verify-gbcs.R` matches all 686 records uniquely to `TH.data::GBSG2` using six baseline covariates, verifies recurrence times, and confirms menopausal and hormone-therapy labels. The initial check used `TH.data` version 1.1-5. This comparison supplies evidence for labels only; all distributed values come from the source repository. See Hothorn, T. (2025), *TH.data: TH's Data Archive*, and its `GBSG2` documentation at <https://CRAN.R-project.org/package=TH.data>.
- UIS: source tokens are identical between editions, while the original variable descriptions differ for the event indicator and depression-score name. The shared `uis` dataset uses the second-edition name `beck`. Both descriptions and the difference in race-category wording are documented in its help page.
- Recurrent events: source tokens are identical between editions. One `recur` dataset represents both editions. The source row order is not chronological within subjects and is preserved.
- FRTCS: visit-1 date and visit-0 medication descriptions conflict with the suffixes and adjacent descriptions. The help page labels the visit interpretation as an inference. The clinical endpoint is not defined in the codebook.
- ACTG 320: the source describes CD4 units as cells/millilitre. The documentation records that statement without rescaling values or asserting an independently verified unit.
- ACTG 320 nested case-control: the 96 case identifiers exactly match all 96 composite AIDS/death events in the supplied full cohort, including its 26 deaths. Comparison of identifiers and jittered times establishes the sampled endpoint; the installed-package tests reproduce this check.
- WHAS nested case-control: the two editions differ in both rows and variables. `nr` describes the underlying risk-set size; it is not the size of the six-record sampled set. Missing values are preserved.
- First-edition WHAS tie-breaking: the codebook states a Uniform(0, 1) subtraction, but the observed adjustments span only 0 to 0.01 days; 18 event records have no visible adjustment at the supplied precision. These values remain unchanged.
- GRACE: six untreated patients have `days = 0.5` and `revascdays = 0`, consistent with the source's half-day convention for same-day follow-up. Two systolic blood-pressure values are zero; the source does not define these as missing, so they remain zero.

The first-edition book is cited as Hosmer and Lemeshow (1999), ISBN 9780471154105, although the source codebooks cite 1998. The second edition is Hosmer, Lemeshow, and May (2008), DOI 10.1002/9780470258019. The source repository's first-edition README attribution to May is not carried over.

The original files and their existing rights are preserved. No explicit dataset licence is present in the upstream repository; see the package `LICENSE` file.
