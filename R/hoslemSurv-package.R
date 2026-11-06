#' Datasets from Both Editions of Applied Survival Analysis
#'
#' An unofficial data-only companion to the first and second editions of Applied Survival Analysis: Regression Modeling of Time to Event Data.
#'
#' @details
#' The package contains 16 datasets. Each help page identifies the book edition and describes the variables, category codes, units, and endpoints. The shared datasets \code{\link{recur}} and \code{\link{uis}} represent both editions using second-edition variable names. Only \code{\link{whasncc_e1}} and \code{\link{whasncc_e2}} retain edition suffixes because their records and variables differ.
#'
#' Variable names are lower case, category codes are numeric, calendar dates are \code{Date} objects, and missing-value dots are represented by \code{NA}. Source row order and numeric values are preserved.
#' @section Original files:
#' Original data files and codebooks from both editions are included in the installed package's \file{extdata} directory. Use \code{system.file("extdata", package = "hoslemSurv")} to locate them.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}: SAS and SPSS downloads for selected second-edition datasets, with analysis examples for Stata, SPSS, and SAS.
#' @section Licensing:
#' Original package code, documentation, and artwork by Graeme L. Hickey are dedicated under CC0 1.0 Universal, to the extent of his rights in those contributions. Third-party datasets and codebooks retain their existing rights; see the package LICENSE file.
#' @author Graeme L. Hickey
#' @seealso \code{\link{hmohiv}}, \code{\link{whas500}}, \code{\link{gbcs}}
#' @examples
#' data(package = "hoslemSurv")
#' data("whas500", package = "hoslemSurv")
#' head(whas500)
#' system.file("extdata", "edition2", "whas500.dat", package = "hoslemSurv")
#' @keywords package datasets
"_PACKAGE"
