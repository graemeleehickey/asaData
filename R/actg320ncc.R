#' ACTG 320 Nested Case-Control Sample (Second Edition)
#'
#' Nested case-control data for the ACTG 320 example in Section 9.4, comprising 96 matched sets.
#'
#' @format A data frame with 576 rows and 7 variables:
#' \describe{
#'   \item{set}{Integer. Matched case-control set identifier, 1 to 96.}
#'   \item{case}{Integer. Status in the sampled set: 1 = case; 0 = control.}
#'   \item{id}{Integer. Original ACTG 320 participant identifier; participants may appear in more than one matched set.}
#'   \item{time}{Numeric. Follow-up time, in days. The codebook states that case times were jittered to break ties.}
#'   \item{tx}{Integer. Treatment indicator: 1 = regimen includes indinavir (IDV); 0 = regimen without IDV.}
#'   \item{age}{Integer. Age at enrolment, in years.}
#'   \item{cd4}{Numeric. Baseline CD4 count, in cells/millilitre as stated in the codebook.}
#' }
#' @details
#' Each row represents a sampled case or control. The sample contains 96 matched sets, each with one case and five controls. Participants may appear in more than one set.
#'
#' \code{case} identifies cases and controls, and \code{set} identifies the matched sets. Case follow-up times in \code{time} are jittered to break ties.
#' @source
#' \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site}.
#' @references
#' Hosmer, D. W., Jr., Lemeshow, S., and May, S. (2008). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. Second edition. Wiley. \doi{10.1002/9780470258019}.
#' @seealso \code{\link{actg320}}
#' @examples
#' data(actg320ncc, package = "asaData")
#' length(unique(actg320ncc$id))
#' table(table(actg320ncc$set))
#' @keywords datasets
"actg320ncc"
