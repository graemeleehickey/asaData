#' WHAS Nested Case-Control Sample (Second Edition)
#'
#' Nested case-control data for the Worcester Heart Attack Study, used in the Chapter 9 exercises.
#'
#' @format A data frame with 1,638 rows and 11 variables:
#' \describe{
#'   \item{set}{Integer. Matched case-control set identifier.}
#'   \item{case}{Integer. Status within this sampled set: 0 = control; 1 = case.}
#'   \item{t}{Numeric. Follow-up time with ties broken, in days.}
#'   \item{lenfol}{Integer. Total follow-up from hospital admission, in days.}
#'   \item{fstat}{Integer. Vital status at last follow-up in the cohort: 0 = alive; 1 = dead.}
#'   \item{age}{Integer. Age recorded in the chart, in years.}
#'   \item{sex}{Integer. Recorded sex: 0 = male; 1 = female.}
#'   \item{bmi}{Numeric. Body mass index, in kg/m^2.}
#'   \item{chf}{Integer. Left heart failure complication: 0 = no; 1 = yes.}
#'   \item{miord}{Integer. Myocardial infarction order: 0 = first; 1 = recurrent.}
#'   \item{nr}{Integer. Size of the underlying cohort risk set at sampling. Missing values: 1365.}
#' }
#' @details
#' Each row represents a sampled case or control within a risk set. There are 273 matched sets, each with one case and five controls. Individuals may appear in multiple risk sets.
#'
#' \code{case} identifies cases and controls, and \code{set} identifies the matched sets. \code{fstat} records vital status in the underlying cohort.
#'
#' The editions contain different sampled records and variables. The first edition has 1,494 rows in 249 matched sets and 12 variables; the second has 1,638 rows in 273 sets and 11 variables. The second edition includes \code{bmi} but omits \code{yrgrp} and \code{lenstay}.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{whasncc_e1}}
#' @examples
#' data(whasncc_e2, package = "asaData")
#' table(table(whasncc_e2$set))
#' with(whasncc_e2, table(case, fstat))
#' @keywords datasets
"whasncc_e2"
