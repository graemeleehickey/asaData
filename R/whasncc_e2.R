#' WHAS Nested Case-Control Sample (Second Edition)
#'
#' Nested case-control data for the Worcester Heart Attack Study, used in the Chapter 9 exercises.
#'
#' @format A data frame with 1,638 rows and 11 variables:
#' \describe{
#'   \item{set}{Integer. Matched case-control set identifier.}
#'   \item{case}{Integer. Status within this sampled set: 0 = control; 1 = case.}
#'   \item{t}{Numeric. Follow-up time with ties broken, in days: lenfol when fstat = 0, and lenfol minus a Uniform(0, 1) draw when fstat = 1. This follows each sampled person's eventual outcome, not the case indicator in the current set.}
#'   \item{lenfol}{Integer. Total follow-up from hospital admission, in days.}
#'   \item{fstat}{Integer. Vital status at last follow-up in the cohort: 0 = alive; 1 = dead. A sampled control can subsequently die, so fstat need not equal case.}
#'   \item{age}{Integer. Age recorded in the chart, in years.}
#'   \item{sex}{Integer. Recorded sex: 0 = male; 1 = female.}
#'   \item{bmi}{Numeric. Body mass index, in kg/m^2.}
#'   \item{chf}{Integer. Left heart failure complication: 0 = no; 1 = yes.}
#'   \item{miord}{Integer. Myocardial infarction order: 0 = first; 1 = recurrent.}
#'   \item{nr}{Integer. Size of the underlying cohort risk set at sampling, not the six-person matched set. Missing source entries remain NA. Missing values: 1365.}
#' }
#' @details
#' One row represents one sampled case or control within a risk set. There are 273 matched sets, each containing one case and five controls. Individuals can appear in multiple risk sets; no subject identifier is provided.
#'
#' Use case as the response and set as the matching stratum in a nested case-control analysis. Do not treat all rows as independent cohort participants or substitute fstat for case.
#'
#' This version contains 1,638 sampled records and differs from the first-edition data. nr is supplied for the 273 case rows only, ranges from 81 to 645, and is missing in all 1,365 control rows. The values describe the original risk sets; the supplied codebook does not establish a row-level link to whas500_e2.
#'
#' The two editions contain different sampled records and variables. The first edition has 1,494 rows in 249 matched sets and 12 variables; the second has 1,638 rows in 273 sets and 11 variables. The second edition includes bmi but omits yrgrp and lenstay. Both have one case and five controls per set.
#'
#' Variable names are lower case. Numeric category codes and source row order are preserved; categories are not converted to factors. A dot (.) in a source numeric field is imported as NA. Dates are converted to R Date objects. No rows are removed, no missing values are imputed, and no supplied numeric values are corrected.
#'
#' @source
#' Data file: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/whasncc.dat}{edition2/whasncc.dat}.
#'
#' Variable descriptions: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/whasncc.txt}{edition2/whasncc.txt}.
#'
#' Repository commit: \code{59a56c509c81898d3853763afcf71686234a1326}. The repository identifies the \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site} as the original download location.
#'
#' For the second edition, the \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page} provides freely downloadable data in SAS and SPSS formats, with analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{whasncc_e1}}
#' @examples
#' data(whasncc_e2, package = "hoslemSurv")
#' table(table(whasncc_e2$set))
#' with(whasncc_e2, table(case, fstat))
#' @keywords datasets
"whasncc_e2"
