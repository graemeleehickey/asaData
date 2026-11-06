#' Bronchopulmonary Dysplasia Data (Second Edition)
#'
#' Oxygen-use follow-up for 78 subjects in the BPD dataset used in Chapter 2.
#'
#' @format A data frame with 78 rows and 4 variables:
#' \describe{
#'   \item{id}{Integer. Subject identifier, 1 to 78.}
#'   \item{surfact}{Integer. Surfactant use: 0 = no; 1 = yes.}
#'   \item{ondays}{Integer. Time on oxygen, in days, to discontinuation or the end of follow-up.}
#'   \item{censor}{Integer. Outcome indicator: 1 = off oxygen; 0 = still on oxygen at study end.}
#' }
#' @details
#' One row represents one subject. The event is discontinuation of oxygen, not death. Use ondays with event indicator censor == 1. The source codebook supplies no additional eligibility criteria.
#'
#' Variable names are lower case. Numeric category codes and source row order are preserved; categories are not converted to factors. A dot (.) in a source numeric field is imported as NA. Dates are converted to R Date objects. No rows are removed, no missing values are imputed, and no supplied numeric values are corrected.
#'
#' @source
#' Data file: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/bpd.dat}{edition2/bpd.dat}.
#'
#' Variable descriptions: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition2/bpd.txt}{edition2/bpd.txt}.
#'
#' Repository commit: \code{59a56c509c81898d3853763afcf71686234a1326}. The repository identifies the Wiley companion FTP site as the original source.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @examples
#' data(bpd_e2, package = "hoslemSurv")
#' str(bpd_e2)
#' head(bpd_e2)
#' @keywords datasets
"bpd_e2"
