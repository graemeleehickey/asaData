#' Hypothetical HMO-HIV Study (First Edition)
#'
#' Follow-up of 100 hypothetical HIV-positive members of a health maintenance organisation, used in Table 1.1 of the first edition.
#'
#' @format A data frame with 100 rows and 7 variables:
#' \describe{
#'   \item{id}{Integer. Subject identifier, 1 to 100.}
#'   \item{entdate}{Date. Study entry date, stored as an R Date.}
#'   \item{enddate}{Date. End-of-follow-up date, stored as an R Date. For an observed death this is the event date; otherwise it is the censoring date.}
#'   \item{time}{Integer. Recorded survival or censoring time in approximate months. See the note on the source codebook below.}
#'   \item{age}{Integer. Age in years.}
#'   \item{drug}{Integer. History of intravenous drug use: 0 = no; 1 = yes.}
#'   \item{censor}{Integer. Follow-up outcome: 1 = death due to AIDS or AIDS-related factors; 0 = alive at study end or lost to follow-up.}
#' }
#' @details
#' One row represents one subject. The event for survival analysis is censor == 1.
#'
#' The source codebook labels time as days, but the supplied values are in approximate months: all 100 equal the rounded date difference divided by 365.25/12. For example, subject 1 has time = 5 and 152 days between entry and end of follow-up. The original time values are retained. Calendar days can be calculated directly from enddate - entdate.
#'
#' The codebook also labels enddate as an entry date; it is the end-of-follow-up date. Both date columns are parsed from the original day-month-abbreviation-two-digit-year strings.
#'
#' Variable names are lower case. Numeric category codes and source row order are preserved; categories are not converted to factors. A dot (.) in a source numeric field is imported as NA. Dates are converted to R Date objects. No rows are removed, no missing values are imputed, and no supplied numeric values are corrected.
#'
#' @source
#' Data file: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition1/hmohiv.dat}{edition1/hmohiv.dat}.
#'
#' Variable descriptions: \href{https://github.com/graemeleehickey/hosmer-lemeshow/blob/59a56c509c81898d3853763afcf71686234a1326/edition1/hmohiv.txt}{edition1/hmohiv.txt}.
#'
#' Repository commit: \code{59a56c509c81898d3853763afcf71686234a1326}. The repository identifies the \href{https://ftp.wiley.com/public/sci_tech_med/survival/}{Wiley companion data site} as the original download location.
#'
#' For the second edition, the \href{https://stats.oarc.ucla.edu/other/examples/asa2/}{UCLA companion page} provides freely downloadable data in SAS and SPSS formats, with analysis examples for Stata, SPSS, and SAS.
#' @references
#' Hosmer, D. W., Jr. and Lemeshow, S. (1999). \emph{Applied Survival Analysis: Regression Modeling of Time to Event Data}. First edition. Wiley. ISBN 978-0-471-15410-5.
#'
#' The supplied first-edition codebooks cite 1998; the published first edition is cited here as 1999.
#' @examples
#' data(hmohiv_e1, package = "hoslemSurv")
#' with(hmohiv_e1, table(drug, censor))
#' with(hmohiv_e1, head(as.numeric(enddate - entdate)))
#' @keywords datasets
"hmohiv_e1"
