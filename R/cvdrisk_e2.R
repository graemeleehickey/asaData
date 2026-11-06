#' Cardiovascular Competing-Risks Example (Second Edition)
#'
#' The 65-record CVD risk competing-risks example from Section 9.6.
#'
#' @format A data frame with 65 rows and 6 variables:
#' \describe{
#'   \item{id}{Integer. Subject identifier.}
#'   \item{age}{Integer. Age in years.}
#'   \item{bmi}{Numeric. Body mass index, in kg/m^2.}
#'   \item{gender}{Integer. Recorded sex: 0 = male; 1 = female.}
#'   \item{time}{Numeric. Follow-up to the recorded event or censoring, in days. Original values, including fractional days where present, are retained.}
#'   \item{ev_typ}{Integer. Endpoint type: 1 = cardiovascular disease (CVD); 2 = other cause; 0 = censored.}
#' }
#' @details
#' One row represents one subject. ev_typ is a three-level outcome, not a binary censoring indicator. For a cause-specific CVD analysis use ev_typ == 1; for a multi-state or cumulative-incidence analysis retain both event types with an explicit censoring level.
#'
#' The supplied codebook describes the causes only as CVD and other cause. It does not further specify the clinical event definition. No undocumented event labels or eligibility restrictions are added.
#'
#' Variable names are lower case. Numeric category codes and source row order are preserved; categories are not converted to factors. A dot (.) in a source numeric field is imported as NA. Dates are converted to R Date objects. No rows are removed, no missing values are imputed, and no supplied numeric values are corrected.
#'
#' @source
#' Data file: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/cvdrisk.dat}{edition2/cvdrisk.dat}.
#'
#' Variable descriptions: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/cvdrisk.txt}{edition2/cvdrisk.txt}.
#'
#' Repository commit: \code{59a56c509c81898d3853763afcf71686234a1326}. The repository identifies the \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site} as the original download location.
#'
#' For the second edition, the \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page} provides freely downloadable data in SAS and SPSS formats, with analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{comprisk_e2}}
#' @examples
#' data(cvdrisk_e2, package = "hoslemSurv")
#' table(cvdrisk_e2$ev_typ)
#' @keywords datasets
"cvdrisk_e2"
