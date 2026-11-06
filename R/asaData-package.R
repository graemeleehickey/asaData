#' Download Datasets from Applied Survival Analysis
#'
#' An unofficial companion package to the first and second editions of Applied Survival Analysis: Regression Modeling of Time to Event Data.
#'
#' @details
#' Use \code{\link{download_asa_all}} to download all 16 datasets as a named list.
#'
#' Use \code{\link{download_asa}} for a single dataset. Each help page identifies the book edition and describes the variables, category codes, units, and endpoints. The shared \code{\link{recur}} and \code{\link{uis}} datasets follow the second-edition definitions. The different WHAS nested case-control samples are available as \code{\link{whasncc_e1}} and \code{\link{whasncc_e2}}.
#'
#' Variable names are lower case, category codes are numeric, calendar dates are \code{Date} objects, and missing-value dots are represented by \code{NA}. Source row order and numeric values are preserved.
#' @section Source files:
#' No dataset records or original codebooks are included in the package. Downloads prefer Wiley, with verified UCLA alternatives for six datasets, and are cached for the current R session by default. Use \code{\link{read_asa}} to import one dataset from a local file, ZIP archive, or folder, or \code{\link{read_asa_all}} to import all available datasets together. Supplying both Wiley archives to \code{read_asa_all()} returns a named list of all 16 datasets without internet access. Every import checks the source checksum, dimensions, missing-value counts, and variable types.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}: examples and alternative data files.
#' @section Licensing:
#' Package code and original documentation are distributed under the \href{https://www.r-project.org/Licenses/GPL-3}{GNU General Public License, version 3 (GPL-3)}. Downloaded datasets and codebooks retain their existing rights and are subject to the source terms.
#' @author Graeme L. Hickey
#' @seealso \code{\link{download_asa}}, \code{\link{read_asa}}, \code{\link{asa_datasets}}
#'
#' \code{vignette("survival-examples", package = "asaData")} for analyses using the \pkg{survival} package.
#' @examples
#' asa_datasets()
#' \dontrun{
#' whas500 <- download_asa("whas500")
#' head(whas500)
#' }
#' @keywords package datasets
"_PACKAGE"
