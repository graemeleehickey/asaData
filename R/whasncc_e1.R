#' WHAS Nested Case-Control Sample (First Edition)
#'
#' Nested case-control data for the Worcester Heart Attack Study, used in the Chapter 9 exercises.
#'
#' @format A data frame with 1,494 rows and 12 variables:
#' \describe{
#'   \item{set}{Integer. Matched case-control set identifier.}
#'   \item{case}{Integer. Status within this sampled set: 0 = control; 1 = case.}
#'   \item{t}{Numeric. Follow-up time with ties broken, in days, as supplied. It equals lenfol when fstat = 0. The codebook describes subtraction of a Uniform(0, 1) draw when fstat = 1, but the supplied differences are much smaller; see below. The adjustment follows each sampled person's eventual outcome, not the case indicator in the current set.}
#'   \item{lenfol}{Integer. Total follow-up from hospital admission, in days.}
#'   \item{fstat}{Integer. Vital status at last follow-up in the cohort: 0 = alive; 1 = dead. A sampled control can subsequently die, so fstat need not equal case.}
#'   \item{age}{Integer. Age recorded in the chart, in years.}
#'   \item{sex}{Integer. Recorded sex: 0 = male; 1 = female.}
#'   \item{chf}{Integer. Left heart failure complication: 0 = no; 1 = yes.}
#'   \item{miord}{Integer. Myocardial infarction order: 0 = first; 1 = recurrent.}
#'   \item{yrgrp}{Integer. Grouped cohort-year code: 1 = 1975 and 1978; 2 = 1981 and 1984; 3 = 1986 and 1988.}
#'   \item{lenstay}{Integer. Length of hospital stay, in days.}
#'   \item{nr}{Integer. Size of the underlying cohort risk set at sampling, not the six-person matched set. Missing source entries remain NA. Missing values: 858.}
#' }
#' @details
#' One row represents one sampled case or control within a risk set. There are 249 matched sets, each containing one case and five controls. Individuals can appear in multiple risk sets; no subject identifier is provided.
#'
#' Use case as the response and set as the matching stratum in a nested case-control analysis. Do not treat all rows as independent cohort participants or substitute fstat for case.
#'
#' This version was constructed from the first-edition WHAS cohort. nr is missing in 858 rows; the 636 nonmissing values range from 48 to 481. Nonmissing nr values also occur in some control rows.
#'
#' Among the 636 records with fstat = 1, lenfol - t ranges from 0 to 0.01 days; 18 records have t equal to lenfol at the supplied precision. This differs from the codebook's stated Uniform(0, 1) adjustment. Values are retained without adding further jitter.
#'
#' Variable names are lower case. Numeric category codes and source row order are preserved; categories are not converted to factors. A dot (.) in a source numeric field is imported as NA. Dates are converted to R Date objects. No rows are removed, no missing values are imputed, and no supplied numeric values are corrected.
#'
#' @source
#' Data file: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition1/whasncc.dat}{edition1/whasncc.dat}.
#'
#' Variable descriptions: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition1/whasncc.txt}{edition1/whasncc.txt}.
#'
#' Repository commit: \code{59a56c509c81898d3853763afcf71686234a1326}. The repository identifies the Wiley companion FTP site as the original source.
#' @references
#' Hosmer, D. W., Jr. and Lemeshow, S. (1999). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. First edition. Wiley. ISBN 978-0-471-15410-5.
#'
#' The supplied first-edition codebooks cite 1998; the published first edition is cited here as 1999.
#' @seealso \code{\link{whasncc_e2}}
#' @examples
#' data(whasncc_e1, package = "hoslemSurv")
#' table(table(whasncc_e1$set))
#' with(whasncc_e1, table(case, fstat))
#' @keywords datasets
"whasncc_e1"
