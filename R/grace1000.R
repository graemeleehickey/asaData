#' GRACE Acute Coronary Syndrome Data (Second Edition)
#'
#' The 1,000-record GRACE dataset used in Chapter 7 and described in Table 7.4.
#'
#' @format A data frame with 1,000 rows and 9 variables:
#' \describe{
#'   \item{id}{Integer. Patient identifier, 1 to 1000.}
#'   \item{days}{Numeric. Follow-up to death or censoring, in days, from 0.5 to 180. Same-day deaths or discharges are assigned 0.5 days in the source description.}
#'   \item{death}{Integer. Death during follow-up: 1 = death; 0 = censored.}
#'   \item{revasc}{Integer. Revascularisation performed: 1 = yes; 0 = no.}
#'   \item{revascdays}{Integer. Days from admission to revascularisation when \code{revasc = 1}, or recorded follow-up time when \code{revasc = 0}.}
#'   \item{los}{Integer. Length of hospital stay, in days.}
#'   \item{age}{Integer. Age at admission, in years.}
#'   \item{sysbp}{Integer. Systolic blood pressure on admission, in mmHg.}
#'   \item{stchange}{Integer. ST-segment deviation on the index electrocardiogram: 1 = yes; 0 = no.}
#' }
#' @details
#' Each row represents a patient. \code{days} records mortality follow-up, with \code{death == 1} indicating death. Same-day deaths or discharges are assigned 0.5 days.
#'
#' For patients with \code{revasc == 1}, \code{revascdays} gives the time from admission to revascularisation.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#'
#' \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page}: SAS and SPSS downloads and analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @examples
#' data(grace1000, package = "hoslemSurv")
#' str(grace1000)
#' head(grace1000)
#' @keywords datasets
"grace1000"
