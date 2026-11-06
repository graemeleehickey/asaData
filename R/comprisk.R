#' Competing-Risks Exercise (Second Edition)
#'
#' The 453-record competing-risks exercise dataset from Chapter 9.
#'
#' @format A data frame with 453 rows and 6 variables:
#' \describe{
#'   \item{id}{Integer. Subject identifier.}
#'   \item{age}{Integer. Age in years.}
#'   \item{gender}{Integer. Recorded sex: 0 = male; 1 = female.}
#'   \item{bmi}{Numeric. Body mass index, in kg/m^2.}
#'   \item{time}{Integer. Follow-up to the recorded event or censoring, in days.}
#'   \item{ev_typ}{Integer. Endpoint type: 1 = cardiovascular disease (CVD); 2 = other cause; 0 = censored.}
#' }
#' @details
#' Each row represents a subject. \code{time} records follow-up in days. \code{ev_typ} distinguishes cardiovascular disease (1), other causes (2), and censoring (0).
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{cvdrisk}}
#' @examples
#' data(comprisk, package = "hoslemSurv")
#' table(comprisk$ev_typ)
#' @keywords datasets
"comprisk"
