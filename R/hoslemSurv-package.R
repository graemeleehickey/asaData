#' Datasets from Both Editions of Applied Survival Analysis
#'
#' An unofficial data-only companion to the first and second editions of Applied Survival Analysis: Regression Modeling of Time to Event Data.
#'
#' @details
#' The package contains 16 datasets covering all 18 source data files. The shared datasets \code{\link{recur}} and \code{\link{uis}} represent both editions and use second-edition variable names. Other names ending in \code{_e1} refer to the first edition (Hosmer and Lemeshow, 1999), and those ending in \code{_e2} to the second edition (Hosmer, Lemeshow, and May, 2008). Every dataset has its own help page with variable definitions, category codes, units, endpoints, and provenance.
#'
#' Names are lower case, category codes are retained as numeric values, calendar dates are R Date objects, and missing-value dots are represented by NA. No records are excluded or imputed. The supplied source files and an R import script are retained in the package's GitHub repository.
#'
#' Some source codebooks contain inconsistent labels or incomplete definitions. These are addressed explicitly in the relevant help pages. Original data values are preserved.
#' @section Edition comparisons:
#' The recur source files have identical values and variable names and are represented by one dataset. The uis source files also have identical values; the packaged column beck follows the second edition, where it replaces the first-edition name becktota. The UIS source codebooks describe the event indicator differently, as explained in \code{\link{uis}}. The separately retained whasncc_e1 and whasncc_e2 datasets differ in records and variables: 1,494 rows and 12 variables in the first edition, and 1,638 rows and 11 variables in the second. The WHAS cohort files also differ: whas_e1 has 481 patients, whereas the second edition supplies whas100_e2 and whas500_e2.
#' @section Download sources and analysis examples:
#' The source repository identifies the \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site} as the original download location for the book's data files.
#'
#' The \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA second-edition companion page} provides freely downloadable data in SAS and SPSS formats, with analysis examples for Stata, SPSS, and SAS. The data in this package were imported from the original files preserved in the source repository, as identified on each dataset's help page.
#' @section Licensing:
#' Original package code and documentation by Graeme L. Hickey are dedicated under CC0 1.0 Universal, to the extent of his rights in those contributions. Third-party datasets, original codebooks, and their underlying content are excluded from that dedication. Their availability for download does not establish redistribution terms. No explicit dataset licence is supplied in the source repository; see the package LICENSE file.
#' @author Graeme L. Hickey
#' @seealso \code{\link{hmohiv_e1}}, \code{\link{whas500_e2}}, \code{\link{gbcs_e2}}
#' @examples
#' data(package = "hoslemSurv")
#' data("whas500_e2", package = "hoslemSurv")
#' head(whas500_e2)
#' @keywords package datasets
"_PACKAGE"
