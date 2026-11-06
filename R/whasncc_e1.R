#' WHAS Nested Case-Control Sample (First Edition)
#'
#' Nested case-control data for the Worcester Heart Attack Study, used in the Chapter 9 exercises.
#'
#' @format A data frame with 1,494 rows and 12 variables:
#' \describe{
#'   \item{set}{Integer. Matched case-control set identifier.}
#'   \item{case}{Integer. Status within this sampled set: 0 = control; 1 = case.}
#'   \item{t}{Numeric. Follow-up time with ties broken, in days.}
#'   \item{lenfol}{Integer. Total follow-up from hospital admission, in days.}
#'   \item{fstat}{Integer. Vital status at last follow-up in the cohort: 0 = alive; 1 = dead.}
#'   \item{age}{Integer. Age recorded in the chart, in years.}
#'   \item{sex}{Integer. Recorded sex: 0 = male; 1 = female.}
#'   \item{chf}{Integer. Left heart failure complication: 0 = no; 1 = yes.}
#'   \item{miord}{Integer. Myocardial infarction order: 0 = first; 1 = recurrent.}
#'   \item{yrgrp}{Integer. Grouped cohort-year code: 1 = 1975 and 1978; 2 = 1981 and 1984; 3 = 1986 and 1988.}
#'   \item{lenstay}{Integer. Length of hospital stay, in days.}
#'   \item{nr}{Integer. Size of the underlying cohort risk set at sampling. Missing values: 858.}
#' }
#' @details
#' Each row represents a sampled case or control within a risk set. There are 249 matched sets, each with one case and five controls. Individuals may appear in multiple risk sets.
#'
#' \code{case} identifies cases and controls, and \code{set} identifies the matched sets. \code{fstat} records vital status in the underlying cohort.
#'
#' The editions contain different sampled records and variables. The first edition has 1,494 rows in 249 matched sets and 12 variables; the second has 1,638 rows in 273 sets and 11 variables. The second edition includes \code{bmi} but omits \code{yrgrp} and \code{lenstay}.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#' @references
#' Hosmer, D. W., Jr. and Lemeshow, S. (1999). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. First edition. Wiley. ISBN 978-0-471-15410-5.
#' @seealso \code{\link{whasncc_e2}}
#' @examples
#' data(whasncc_e1, package = "hoslemSurv")
#' table(table(whasncc_e1$set))
#' with(whasncc_e1, table(case, fstat))
#' @keywords datasets
"whasncc_e1"
